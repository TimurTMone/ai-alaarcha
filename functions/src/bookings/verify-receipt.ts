import { onDocumentUpdated } from 'firebase-functions/v2/firestore';
import { defineSecret } from 'firebase-functions/params';
import { Timestamp } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';
import Anthropic from '@anthropic-ai/sdk';
import { db } from '../utils/admin';
import { issueBookingQr, qrSigningSecret } from './issue-qr';

const anthropicApiKey = defineSecret('ANTHROPIC_API_KEY');

const EXTRACTION_PROMPT = `You are a receipt verification assistant for Ala-Archa National Park in Kyrgyzstan.

Extract the following from the attached bank receipt image. The receipt may be from MBank, O!Dengi, Bakai Bank, KICB, or another Kyrgyz bank, in Russian, Kyrgyz, or English.

Return ONLY a JSON object in this exact shape — no prose, no markdown fences:

{
  "amount": <number in KGS som, e.g. 1500>,
  "date": "<ISO 8601 date, e.g. 2026-04-05>",
  "sender": "<sender name if visible, else null>",
  "recipient": "<recipient name/account if visible, else null>",
  "memo": "<transfer memo / comment / назначение платежа, exactly as written, else null>",
  "confidence": <0.0 to 1.0, your confidence the data was read correctly>
}

If the image is not a bank receipt at all, return {"amount": null, "date": null, "sender": null, "recipient": null, "memo": null, "confidence": 0}.`;

interface ExtractedReceipt {
  amount: number | null;
  date: string | null;
  sender: string | null;
  recipient: string | null;
  memo: string | null;
  confidence: number;
}

/**
 * Fires when a booking's receiptUrl is added and status becomes
 * pendingVerification. Downloads the image, asks Claude Vision to extract
 * the fields, compares against expected values, and either auto-approves
 * (issuing the QR) or flags the booking for human review.
 */
export const verifyReceipt = onDocumentUpdated(
  {
    document: 'bookings/{bookingId}',
    secrets: [anthropicApiKey, qrSigningSecret],
    timeoutSeconds: 60,
    memory: '512MiB',
  },
  async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after) return;

    // Only run when the booking just entered pendingVerification with a receipt.
    const becamePending =
      before.status !== 'pendingVerification' &&
      after.status === 'pendingVerification';
    const gotReceipt = !before.receiptUrl && !!after.receiptUrl;
    if (!becamePending && !gotReceipt) return;
    if (!after.receiptUrl) return;

    const bookingId = event.params.bookingId;
    const bookingRef = db.collection('bookings').doc(bookingId);

    try {
      // ── 1. Load receipt image bytes from Storage ───────────────────────
      const imageBytes = await loadImageFromUrl(
        after.receiptUrl as string,
        after.userId as string,
        bookingId
      );
      if (!imageBytes) {
        await bookingRef.update({
          status: 'needsReview',
          aiVerification: {
            score: 0,
            notes: 'Could not load receipt image from storage',
          },
        });
        return;
      }

      // ── 2. Ask Claude Vision to extract fields ─────────────────────────
      const client = new Anthropic({ apiKey: anthropicApiKey.value() });
      const response = await client.messages.create({
        model: 'claude-sonnet-4-6',
        max_tokens: 512,
        messages: [
          {
            role: 'user',
            content: [
              {
                type: 'image',
                source: {
                  type: 'base64',
                  media_type: 'image/jpeg',
                  data: imageBytes.toString('base64'),
                },
              },
              { type: 'text', text: EXTRACTION_PROMPT },
            ],
          },
        ],
      });

      const textBlock = response.content.find((b) => b.type === 'text');
      if (!textBlock || textBlock.type !== 'text') {
        await bookingRef.update({
          status: 'needsReview',
          aiVerification: {
            score: 0,
            notes: 'Claude returned no text response',
          },
        });
        return;
      }

      const extracted = parseExtraction(textBlock.text);
      if (!extracted) {
        await bookingRef.update({
          status: 'needsReview',
          aiVerification: {
            score: 0,
            notes: `Could not parse Claude output: ${textBlock.text.slice(0, 200)}`,
          },
        });
        return;
      }

      // ── 3. Compare extracted values against booking ────────────────────
      const expectedAmount = after.totalPriceKgs as number;
      const shortRef = bookingId.slice(0, 6).toUpperCase();
      const createdAt = (after.createdAt as Timestamp).toDate();

      const amountMatches =
        extracted.amount !== null &&
        Math.abs(extracted.amount - expectedAmount) <= 1;

      const memoContainsRef =
        !!extracted.memo &&
        extracted.memo.toUpperCase().replace(/\s+/g, '').includes(shortRef);

      const dateIsRecent =
        extracted.date !== null &&
        isDateWithin48h(extracted.date, createdAt);

      // Score: extraction confidence (60%) + hard checks (40%)
      const hardChecksPassed =
        (amountMatches ? 1 : 0) +
        (memoContainsRef ? 1 : 0) +
        (dateIsRecent ? 1 : 0);
      const score =
        extracted.confidence * 0.6 + (hardChecksPassed / 3) * 0.4;

      const notesBuf: string[] = [];
      if (!amountMatches) {
        notesBuf.push(
          `amount mismatch: got ${extracted.amount}, expected ${expectedAmount}`
        );
      }
      if (!memoContainsRef) {
        notesBuf.push(`memo missing ref ${shortRef}`);
      }
      if (!dateIsRecent) notesBuf.push('date outside 48h window');

      const aiVerification = {
        score: round(score, 3),
        extractedAmountKgs: extracted.amount,
        extractedDate: extracted.date
          ? Timestamp.fromDate(new Date(extracted.date))
          : null,
        extractedReference: extracted.memo,
        notes:
          notesBuf.length > 0
            ? notesBuf.join('; ')
            : 'all checks passed',
      };

      // ── 4. Decide: auto-approve or flag for review ────────────────────
      const autoApprove =
        score >= 0.9 && amountMatches && memoContainsRef && dateIsRecent;

      if (autoApprove) {
        const now = new Date();
        const validFrom = (after.startsAt as Timestamp | undefined)?.toDate() ?? now;
        const validToDate = (after.endsAt as Timestamp | undefined)?.toDate() ??
          new Date(validFrom.getTime() + 24 * 60 * 60 * 1000);

        const qrCode = issueBookingQr({
          bookingId,
          userId: after.userId as string,
          subjectType: (after.subjectType as string) ?? 'service',
          subjectId: (after.subjectId as string) ?? '',
          validFrom: validFrom.getTime(),
          validTo: validToDate.getTime(),
        });

        await bookingRef.update({
          status: 'approved',
          qrCode,
          aiVerification,
          approvedAt: Timestamp.now(),
        });
      } else {
        await bookingRef.update({
          status: 'needsReview',
          aiVerification,
        });
      }
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : String(err);
      await bookingRef.update({
        status: 'needsReview',
        aiVerification: {
          score: 0,
          notes: `verification failed: ${errorMessage.slice(0, 200)}`,
        },
      });
    }
  }
);

/** Strips a gs:// or https download URL down to a Storage object path,
 *  then reads it into a Buffer. Falls back to HTTP fetch for public URLs. */
async function loadImageFromUrl(
  url: string,
  userId: string,
  bookingId: string
): Promise<Buffer | null> {
  // Preferred path: we wrote the file at a known location.
  const expectedPath = `receipts/${userId}/${bookingId}.jpg`;
  try {
    const [buf] = await getStorage().bucket().file(expectedPath).download();
    return buf;
  } catch {
    // Fallback: fetch by URL (handles externally-hosted dev images).
    try {
      const res = await fetch(url);
      if (!res.ok) return null;
      const arr = await res.arrayBuffer();
      return Buffer.from(arr);
    } catch {
      return null;
    }
  }
}

function parseExtraction(text: string): ExtractedReceipt | null {
  // Be permissive: Claude sometimes wraps JSON in ```json``` fences.
  const cleaned = text
    .replace(/```json\s*/i, '')
    .replace(/```\s*$/m, '')
    .trim();
  try {
    const obj = JSON.parse(cleaned) as ExtractedReceipt;
    if (typeof obj.confidence !== 'number') return null;
    return obj;
  } catch {
    // Try to find a JSON object somewhere in the text.
    const match = cleaned.match(/\{[\s\S]*\}/);
    if (!match) return null;
    try {
      return JSON.parse(match[0]) as ExtractedReceipt;
    } catch {
      return null;
    }
  }
}

function isDateWithin48h(isoDate: string, createdAt: Date): boolean {
  const d = new Date(isoDate);
  if (isNaN(d.getTime())) return false;
  const diffMs = Math.abs(d.getTime() - createdAt.getTime());
  return diffMs <= 48 * 60 * 60 * 1000;
}

function round(n: number, places: number): number {
  const m = Math.pow(10, places);
  return Math.round(n * m) / m;
}
