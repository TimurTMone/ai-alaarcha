import * as crypto from 'node:crypto';
import { defineSecret } from 'firebase-functions/params';

export const qrSigningSecret = defineSecret('QR_SIGNING_SECRET');

interface BookingQrPayload {
  bookingId: string;
  userId: string;
  subjectType: string;
  subjectId: string;
  validFrom: number; // unix ms
  validTo: number; // unix ms
}

function base64UrlEncode(buf: Buffer): string {
  return buf
    .toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '');
}

/**
 * Builds a signed, base64url-encoded QR payload for a booking.
 *
 * Format: <base64url(json-payload)>.<base64url(hmac-sha256)>
 *
 * Scanners verify by splitting on '.', recomputing the HMAC with the
 * shared secret, and checking `validFrom <= now <= validTo`.
 *
 * Mirrors the signing approach used in passes/create-pass.ts.
 */
export function issueBookingQr(payload: BookingQrPayload): string {
  const secret = qrSigningSecret.value();
  if (!secret) {
    throw new Error('QR_SIGNING_SECRET is not configured');
  }

  const json = JSON.stringify(payload);
  const body = base64UrlEncode(Buffer.from(json, 'utf8'));
  const sig = crypto
    .createHmac('sha256', secret)
    .update(body)
    .digest();
  const signature = base64UrlEncode(sig);

  return `ALAARCHA.${body}.${signature}`;
}

/**
 * Verifies a QR token. Returns payload when valid, null when not.
 */
export function verifyBookingQr(token: string): BookingQrPayload | null {
  const secret = qrSigningSecret.value();
  if (!secret) return null;

  const parts = token.split('.');
  if (parts.length !== 3 || parts[0] !== 'ALAARCHA') return null;
  const [, body, signature] = parts;

  const expectedSig = base64UrlEncode(
    crypto.createHmac('sha256', secret).update(body).digest()
  );
  if (
    signature.length !== expectedSig.length ||
    !crypto.timingSafeEqual(
      Buffer.from(signature),
      Buffer.from(expectedSig)
    )
  ) {
    return null;
  }

  try {
    const padded = body.replace(/-/g, '+').replace(/_/g, '/');
    const json = Buffer.from(padded, 'base64').toString('utf8');
    const payload = JSON.parse(json) as BookingQrPayload;
    const now = Date.now();
    if (now < payload.validFrom || now > payload.validTo) return null;
    return payload;
  } catch {
    return null;
  }
}
