import { getStorage } from 'firebase-admin/storage';
import { FieldValue, Timestamp } from 'firebase-admin/firestore';
import { v4 as uuid } from 'uuid';
import { db } from '../utils/admin';
import { reply, downloadTelegramFile } from './webhook';
import { notifyDirector } from './notify-director';

export interface TelegramMessage {
  type: 'photo' | 'document' | 'text';
  fileId: string;
  caption: string;
  chatId: number;
  userId: number;
  username: string;
  mimeType?: string;
  fileName?: string;
}

// Pending state: when a user sends a photo without a caption, we ask them
// which service it's for. Store { chatId → fileId } so when they reply
// with text, we can match it.
const pendingUploads = new Map<number, TelegramMessage>();

/**
 * Routes a Telegram message based on its caption/command:
 *   /service <name>  → attach photo to matching service
 *   /accom <name>    → attach photo to matching accommodation
 *   /news <title>    → create announcement
 *   /doc <label>     → store as general document
 *   bare photo       → ask "which service?"
 *   text reply       → resolve pending upload
 */
export async function routeMessage(msg: TelegramMessage): Promise<void> {
  const caption = msg.caption.trim();

  // ── Text reply to a pending "which service?" prompt ──
  if (msg.type === 'text' && pendingUploads.has(msg.chatId)) {
    const pending = pendingUploads.get(msg.chatId)!;
    pendingUploads.delete(msg.chatId);
    pending.caption = caption;
    return routeMessage(pending);
  }

  // ── Commands ──
  const serviceMatch = caption.match(/^\/service\s+(.+)/i);
  if (serviceMatch) {
    return handleServicePhoto(msg, serviceMatch[1].trim(), 'services');
  }

  const accomMatch = caption.match(/^\/accom\s+(.+)/i);
  if (accomMatch) {
    return handleServicePhoto(msg, accomMatch[1].trim(), 'accommodations');
  }

  const newsMatch = caption.match(/^\/news\s+(.+)/i);
  if (newsMatch) {
    return handleAnnouncement(msg, newsMatch[1].trim());
  }

  const docMatch = caption.match(/^\/doc\s+(.+)/i);
  if (docMatch) {
    return handleDocument(msg, docMatch[1].trim());
  }

  // ── Photo/doc with a plain caption → try fuzzy match on services ──
  if ((msg.type === 'photo' || msg.type === 'document') && caption) {
    const match = await fuzzyMatchService(caption);
    if (match) {
      return handleServicePhoto(msg, caption, 'services', match);
    }
    // No match — ask
    pendingUploads.set(msg.chatId, msg);
    await reply(
      msg.chatId,
      `🤔 Could not match "${caption}" to a service.\n\nUse commands:\n/service <name>\n/accom <name>\n/news <title>`
    );
    return;
  }

  // ── Bare photo without caption ──
  if (msg.type === 'photo' || msg.type === 'document') {
    pendingUploads.set(msg.chatId, msg);
    await reply(
      msg.chatId,
      '📷 Nice photo! Which service is this for?\n\nReply with the name, or use:\n/service <name>\n/accom <name>\n/news <title>'
    );
    return;
  }

  // ── Unknown text ──
  await reply(
    msg.chatId,
    '📷 Send a photo with a caption, or use:\n/service <name>\n/accom <name>\n/news <title>\n/doc <label>'
  );
}

// ── Service/Accommodation photo upload ──

async function handleServicePhoto(
  msg: TelegramMessage,
  searchTerm: string,
  collection: 'services' | 'accommodations',
  preMatched?: { id: string; name: string }
): Promise<void> {
  if (!msg.fileId) {
    await reply(msg.chatId, '⚠️ Please send a photo with the command.');
    return;
  }

  const match = preMatched ?? (await fuzzyMatchInCollection(searchTerm, collection));
  if (!match) {
    await reply(
      msg.chatId,
      `❌ No ${collection === 'services' ? 'service' : 'accommodation'} found matching "${searchTerm}".`
    );
    return;
  }

  // Download from Telegram → upload to Storage
  const { buffer, filePath } = await downloadTelegramFile(msg.fileId);
  const ext = filePath.split('.').pop() ?? 'jpg';
  const storagePath = `${collection}/${match.id}/photos/${uuid()}.${ext}`;
  const bucket = getStorage().bucket();
  const file = bucket.file(storagePath);
  await file.save(buffer, {
    metadata: { contentType: msg.mimeType ?? `image/${ext}` },
  });
  await file.makePublic();
  const downloadUrl = `https://storage.googleapis.com/${bucket.name}/${storagePath}`;

  // Append to subject doc's images array
  await db.collection(collection).doc(match.id).update({
    images: FieldValue.arrayUnion(downloadUrl),
  });

  // Audit log
  const uploadId = uuid();
  await db.collection('telegram_uploads').doc(uploadId).set({
    telegramUserId: msg.userId,
    telegramUsername: msg.username,
    subjectType: collection === 'services' ? 'service' : 'accommodation',
    subjectId: match.id,
    subjectName: match.name,
    fileUrl: downloadUrl,
    storagePath,
    caption: msg.caption,
    status: 'published',
    createdAt: Timestamp.now(),
  });

  // Count images
  const subjectDoc = await db.collection(collection).doc(match.id).get();
  const imageCount = (subjectDoc.data()?.images as string[] | undefined)?.length ?? 1;

  await reply(
    msg.chatId,
    `✅ Added to <b>${match.name}</b> — ${imageCount} photo${imageCount > 1 ? 's' : ''} now.`
  );

  // Notify director
  await notifyDirector(uploadId, match.name, msg.username);
}

// ── Announcements ──

async function handleAnnouncement(msg: TelegramMessage, title: string): Promise<void> {
  let imageUrl: string | null = null;

  if (msg.fileId) {
    const { buffer, filePath } = await downloadTelegramFile(msg.fileId);
    const ext = filePath.split('.').pop() ?? 'jpg';
    const storagePath = `announcements/${uuid()}.${ext}`;
    const bucket = getStorage().bucket();
    const file = bucket.file(storagePath);
    await file.save(buffer, {
      metadata: { contentType: msg.mimeType ?? `image/${ext}` },
    });
    await file.makePublic();
    imageUrl = `https://storage.googleapis.com/${bucket.name}/${storagePath}`;
  }

  const announcementId = uuid();
  await db.collection('announcements').doc(announcementId).set({
    title: { ru: title, en: title, ky: title },
    body: { ru: '', en: '', ky: '' },
    imageUrl,
    authorTelegramId: msg.userId,
    authorTelegramUsername: msg.username,
    createdAt: Timestamp.now(),
    expiresAt: Timestamp.fromDate(new Date(Date.now() + 14 * 24 * 60 * 60 * 1000)),
  });

  // Audit log
  await db.collection('telegram_uploads').doc(uuid()).set({
    telegramUserId: msg.userId,
    telegramUsername: msg.username,
    subjectType: 'announcement',
    subjectId: announcementId,
    subjectName: title,
    fileUrl: imageUrl,
    caption: msg.caption,
    status: 'published',
    createdAt: Timestamp.now(),
  });

  await reply(msg.chatId, `📢 Announcement "<b>${title}</b>" published!`);
  await notifyDirector(announcementId, `Announcement: ${title}`, msg.username);
}

// ── General documents ──

async function handleDocument(msg: TelegramMessage, label: string): Promise<void> {
  if (!msg.fileId) {
    await reply(msg.chatId, '⚠️ Please send a file with /doc <label>.');
    return;
  }

  const { buffer, filePath } = await downloadTelegramFile(msg.fileId);
  const ext = filePath.split('.').pop() ?? 'bin';
  const storagePath = `documents/${uuid()}.${ext}`;
  const bucket = getStorage().bucket();
  const file = bucket.file(storagePath);
  await file.save(buffer, {
    metadata: { contentType: msg.mimeType ?? 'application/octet-stream' },
  });
  await file.makePublic();
  const downloadUrl = `https://storage.googleapis.com/${bucket.name}/${storagePath}`;

  await db.collection('telegram_uploads').doc(uuid()).set({
    telegramUserId: msg.userId,
    telegramUsername: msg.username,
    subjectType: 'document',
    subjectId: null,
    subjectName: label,
    fileUrl: downloadUrl,
    storagePath,
    caption: msg.caption,
    status: 'published',
    createdAt: Timestamp.now(),
  });

  await reply(msg.chatId, `📄 Document "<b>${label}</b>" uploaded.`);
}

// ── Fuzzy matching ──

async function fuzzyMatchService(
  term: string
): Promise<{ id: string; name: string } | null> {
  return fuzzyMatchInCollection(term, 'services');
}

async function fuzzyMatchInCollection(
  term: string,
  collection: 'services' | 'accommodations'
): Promise<{ id: string; name: string } | null> {
  const snap = await db.collection(collection).get();
  const needle = term.toLowerCase();
  let bestMatch: { id: string; name: string; score: number } | null = null;

  for (const doc of snap.docs) {
    const data = doc.data();
    // Check name in all 3 locales
    const names: string[] = [];
    if (data.name) {
      if (typeof data.name === 'string') {
        names.push(data.name);
      } else {
        for (const locale of ['ru', 'en', 'ky']) {
          if (data.name[locale]) names.push(data.name[locale]);
        }
      }
    }

    for (const name of names) {
      const haystack = name.toLowerCase();
      if (haystack === needle) {
        return { id: doc.id, name };
      }
      if (haystack.includes(needle) || needle.includes(haystack)) {
        const score = Math.abs(haystack.length - needle.length);
        if (!bestMatch || score < bestMatch.score) {
          bestMatch = { id: doc.id, name, score };
        }
      }
    }
  }

  return bestMatch ? { id: bestMatch.id, name: bestMatch.name } : null;
}
