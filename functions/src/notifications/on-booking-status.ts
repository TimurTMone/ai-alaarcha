import { onDocumentUpdated } from 'firebase-functions/v2/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { db } from '../utils/admin';

/**
 * Fires when a booking's status changes. Sends an FCM notification to the
 * booking owner for meaningful transitions: approved, rejected, needsReview.
 */
export const onBookingStatusChange = onDocumentUpdated(
  {
    document: 'bookings/{bookingId}',
    timeoutSeconds: 30,
    memory: '256MiB',
  },
  async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after) return;

    const oldStatus = before.status as string;
    const newStatus = after.status as string;
    if (oldStatus === newStatus) return;

    // Only notify on these transitions.
    const notifyStatuses = ['approved', 'rejected', 'needsReview'];
    if (!notifyStatuses.includes(newStatus)) return;

    const userId = after.userId as string;
    const bookingId = event.params.bookingId;
    const shortRef = bookingId.slice(0, 6).toUpperCase();

    // Get user's FCM tokens and language.
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) return;
    const userData = userDoc.data()!;
    const tokens: string[] = userData.fcmTokens ?? [];
    if (tokens.length === 0) return;
    const lang = (userData.language as string) ?? 'ru';

    const { title, body } = buildMessage(newStatus, shortRef, lang);

    // Send to all tokens; prune invalid ones.
    const response = await getMessaging().sendEachForMulticast({
      tokens,
      notification: { title, body },
      data: {
        type: 'booking_status',
        bookingId,
        status: newStatus,
      },
      apns: {
        payload: {
          aps: { sound: 'default', badge: 1 },
        },
      },
      android: {
        priority: 'high' as const,
        notification: { sound: 'default' },
      },
    });

    // Remove stale tokens.
    const staleTokens: string[] = [];
    response.responses.forEach((r, i) => {
      if (
        r.error &&
        (r.error.code === 'messaging/registration-token-not-registered' ||
          r.error.code === 'messaging/invalid-registration-token')
      ) {
        staleTokens.push(tokens[i]);
      }
    });
    if (staleTokens.length > 0) {
      const { FieldValue } = await import('firebase-admin/firestore');
      await db
        .collection('users')
        .doc(userId)
        .update({ fcmTokens: FieldValue.arrayRemove(...staleTokens) });
    }
  }
);

function buildMessage(
  status: string,
  ref: string,
  lang: string
): { title: string; body: string } {
  const messages: Record<string, Record<string, { title: string; body: string }>> = {
    approved: {
      en: {
        title: 'Booking Approved ✅',
        body: `Your booking ${ref} is confirmed! Open the app to see your QR pass.`,
      },
      ru: {
        title: 'Бронь подтверждена ✅',
        body: `Бронь ${ref} подтверждена! Откройте приложение, чтобы увидеть QR-код.`,
      },
      ky: {
        title: 'Бронь ырасталды ✅',
        body: `${ref} брондоо ырасталды! QR кодду көрүү үчүн колдонмону ачыңыз.`,
      },
    },
    rejected: {
      en: {
        title: 'Booking Not Approved',
        body: `Your booking ${ref} was not approved. Open the app for details.`,
      },
      ru: {
        title: 'Бронь отклонена',
        body: `Бронь ${ref} отклонена. Откройте приложение для подробностей.`,
      },
      ky: {
        title: 'Бронь четке кагылды',
        body: `${ref} бронь четке кагылды. Толугураак маалымат үчүн колдонмону ачыңыз.`,
      },
    },
    needsReview: {
      en: {
        title: 'Receipt Under Review',
        body: `Your receipt for booking ${ref} is being reviewed by our team.`,
      },
      ru: {
        title: 'Чек на проверке',
        body: `Ваш чек по брони ${ref} проверяется нашей командой.`,
      },
      ky: {
        title: 'Чек текшерилүүдө',
        body: `${ref} бронь боюнча чегиңиз командабыз тарабынан текшерилүүдө.`,
      },
    },
  };

  return messages[status]?.[lang] ?? messages[status]?.ru ?? {
    title: 'Booking Update',
    body: `Booking ${ref} status changed to ${status}`,
  };
}
