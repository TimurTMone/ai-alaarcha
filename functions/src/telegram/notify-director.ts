import { getMessaging } from 'firebase-admin/messaging';
import { db } from '../utils/admin';

/**
 * Sends an FCM notification to all users with role == 'director' (or 'admin')
 * when a new Telegram upload is published. Links to the admin moderation page.
 */
export async function notifyDirector(
  uploadId: string,
  subjectName: string,
  uploaderUsername: string
): Promise<void> {
  // Find directors/admins
  const snap = await db
    .collection('users')
    .where('role', 'in', ['director', 'admin'])
    .get();

  const tokens: string[] = [];
  for (const doc of snap.docs) {
    const data = doc.data();
    const userTokens = data.fcmTokens as string[] | undefined;
    if (userTokens) tokens.push(...userTokens);
  }

  if (tokens.length === 0) return;

  await getMessaging().sendEachForMulticast({
    tokens,
    notification: {
      title: '📷 New upload from Telegram',
      body: `@${uploaderUsername} added content to "${subjectName}"`,
    },
    data: {
      type: 'telegram_upload',
      uploadId,
    },
    apns: {
      payload: {
        aps: { sound: 'default' },
      },
    },
  });
}
