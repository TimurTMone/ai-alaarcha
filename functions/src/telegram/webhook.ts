import { onRequest } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { db } from '../utils/admin';
import { routeMessage } from './router';

export const telegramBotToken = defineSecret('TELEGRAM_BOT_TOKEN');

const RATE_LIMIT_PER_HOUR = 20;
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB

/**
 * HTTPS endpoint receiving Telegram webhook updates from @AlaArchaParkBot.
 * Parses photo/document/text messages and routes them via router.ts.
 */
export const telegramWebhook = onRequest(
  {
    secrets: [telegramBotToken],
    timeoutSeconds: 30,
    memory: '256MiB',
  },
  async (req, res) => {
    if (req.method !== 'POST') {
      res.status(405).send('Method not allowed');
      return;
    }

    try {
      const update = req.body;
      const message = update.message;
      if (!message) {
        res.status(200).send('ok');
        return;
      }

      const chatId = message.chat.id;
      const userId = message.from?.id;
      const username = message.from?.username ?? `user_${userId}`;

      // ── Rate limiting ──
      if (userId) {
        const limited = await checkRateLimit(userId);
        if (limited) {
          await reply(chatId, '⏳ Too many uploads. Please wait an hour.');
          res.status(200).send('ok');
          return;
        }
      }

      // ── Determine message type ──
      if (message.photo) {
        // Photo: take highest resolution
        const photo = message.photo[message.photo.length - 1];
        if (photo.file_size && photo.file_size > MAX_FILE_SIZE) {
          await reply(chatId, '⚠️ File too large (max 10 MB).');
          res.status(200).send('ok');
          return;
        }
        const caption = message.caption ?? '';
        await routeMessage({
          type: 'photo',
          fileId: photo.file_id,
          caption,
          chatId,
          userId: userId ?? 0,
          username,
        });
      } else if (message.document) {
        const doc = message.document;
        const mime = doc.mime_type ?? '';
        if (!mime.startsWith('image/') && mime !== 'application/pdf') {
          await reply(chatId, '⚠️ Only images and PDFs are accepted.');
          res.status(200).send('ok');
          return;
        }
        if (doc.file_size && doc.file_size > MAX_FILE_SIZE) {
          await reply(chatId, '⚠️ File too large (max 10 MB).');
          res.status(200).send('ok');
          return;
        }
        const caption = message.caption ?? '';
        await routeMessage({
          type: 'document',
          fileId: doc.file_id,
          caption,
          chatId,
          userId: userId ?? 0,
          username,
          mimeType: mime,
          fileName: doc.file_name,
        });
      } else if (message.text) {
        // Plain text — might be a reply to a "which service?" prompt
        await routeMessage({
          type: 'text',
          fileId: '',
          caption: message.text,
          chatId,
          userId: userId ?? 0,
          username,
        });
      } else {
        await reply(chatId, '📷 Send a photo, PDF, or use commands:\n/service <name>\n/accom <name>\n/news <title>');
      }

      res.status(200).send('ok');
    } catch (err) {
      console.error('Telegram webhook error:', err);
      res.status(200).send('ok'); // Always 200 so Telegram doesn't retry
    }
  }
);

/** Send a text reply back to the user. */
export async function reply(chatId: number, text: string): Promise<void> {
  const token = telegramBotToken.value();
  const url = `https://api.telegram.org/bot${token}/sendMessage`;
  await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ chat_id: chatId, text, parse_mode: 'HTML' }),
  });
}

/** Download a file from Telegram by file_id → Buffer. */
export async function downloadTelegramFile(fileId: string): Promise<{ buffer: Buffer; filePath: string }> {
  const token = telegramBotToken.value();

  // 1. Get file path
  const fileInfoRes = await fetch(
    `https://api.telegram.org/bot${token}/getFile?file_id=${fileId}`
  );
  const fileInfo = (await fileInfoRes.json()) as {
    ok: boolean;
    result: { file_path: string };
  };
  if (!fileInfo.ok) throw new Error('Failed to get file info from Telegram');

  // 2. Download
  const filePath = fileInfo.result.file_path;
  const downloadRes = await fetch(
    `https://api.telegram.org/file/bot${token}/${filePath}`
  );
  if (!downloadRes.ok) throw new Error('Failed to download file from Telegram');

  const arrayBuf = await downloadRes.arrayBuffer();
  return { buffer: Buffer.from(arrayBuf), filePath };
}

/** Rate limit: max RATE_LIMIT_PER_HOUR uploads per Telegram user per hour. */
async function checkRateLimit(telegramUserId: number): Promise<boolean> {
  const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
  const snap = await db
    .collection('telegram_uploads')
    .where('telegramUserId', '==', telegramUserId)
    .where('createdAt', '>', oneHourAgo)
    .count()
    .get();
  return snap.data().count >= RATE_LIMIT_PER_HOUR;
}
