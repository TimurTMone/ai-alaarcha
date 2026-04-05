import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { Timestamp } from 'firebase-admin/firestore';
import { db } from '../utils/admin';
import { issueBookingQr, qrSigningSecret } from './issue-qr';

interface ReviewRequest {
  bookingId: string;
  decision: 'approve' | 'reject';
  note?: string;
}

/**
 * HTTPS callable invoked by the admin dashboard from the pending-bookings
 * queue. Requires `role=admin` on the caller's user doc. Approves or rejects
 * a booking currently in `needsReview`, issuing a signed QR on approval.
 */
export const reviewBooking = onCall(
  { secrets: [qrSigningSecret] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Login required');
    }

    // Verify admin via users/{uid}.role (mirrors firestore.rules isAdmin()).
    const callerUid = request.auth.uid;
    const callerDoc = await db.collection('users').doc(callerUid).get();
    if (!callerDoc.exists || callerDoc.data()?.role !== 'admin') {
      throw new HttpsError('permission-denied', 'Admin role required');
    }

    const { bookingId, decision, note } = request.data as ReviewRequest;
    if (!bookingId || (decision !== 'approve' && decision !== 'reject')) {
      throw new HttpsError('invalid-argument', 'bookingId and decision required');
    }

    const bookingRef = db.collection('bookings').doc(bookingId);
    const snap = await bookingRef.get();
    if (!snap.exists) {
      throw new HttpsError('not-found', 'Booking not found');
    }
    const booking = snap.data()!;
    if (booking.status !== 'needsReview' && booking.status !== 'pendingVerification') {
      throw new HttpsError(
        'failed-precondition',
        `Booking is ${booking.status}; only needsReview/pendingVerification can be reviewed`
      );
    }

    const now = Timestamp.now();

    if (decision === 'approve') {
      const validFromDate =
        (booking.startsAt as Timestamp | undefined)?.toDate() ?? now.toDate();
      const validToDate =
        (booking.endsAt as Timestamp | undefined)?.toDate() ??
        new Date(validFromDate.getTime() + 24 * 60 * 60 * 1000);

      const qrCode = issueBookingQr({
        bookingId,
        userId: booking.userId as string,
        subjectType: (booking.subjectType as string) ?? 'service',
        subjectId: (booking.subjectId as string) ?? '',
        validFrom: validFromDate.getTime(),
        validTo: validToDate.getTime(),
      });

      await bookingRef.update({
        status: 'approved',
        qrCode,
        reviewedBy: callerUid,
        reviewedAt: now,
        approvedAt: now,
        ...(note ? { reviewNote: note } : {}),
      });

      return { success: true, status: 'approved' };
    }

    // reject
    await bookingRef.update({
      status: 'rejected',
      reviewedBy: callerUid,
      reviewedAt: now,
      rejectionReason: note ?? 'Rejected by admin',
    });
    return { success: true, status: 'rejected' };
  }
);
