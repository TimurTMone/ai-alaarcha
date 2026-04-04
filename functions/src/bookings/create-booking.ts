import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { Timestamp } from 'firebase-admin/firestore';
import { v4 as uuid } from 'uuid';
import { db } from '../utils/admin';

export const createBooking = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Login required');

  const { accommodationId, checkIn, checkOut, guests } = request.data;

  // Validate accommodation exists
  const accDoc = await db.collection('accommodations').doc(accommodationId).get();
  if (!accDoc.exists) throw new HttpsError('not-found', 'Accommodation not found');

  const acc = accDoc.data()!;
  if (guests > acc.capacity) {
    throw new HttpsError('invalid-argument', 'Exceeds capacity');
  }

  // Check availability (no overlapping bookings)
  const checkInDate = new Date(checkIn);
  const checkOutDate = new Date(checkOut);

  const overlapping = await db
    .collection('bookings')
    .where('accommodationId', '==', accommodationId)
    .where('status', 'in', ['pending', 'confirmed', 'checked_in'])
    .where('checkIn', '<', Timestamp.fromDate(checkOutDate))
    .get();

  const hasConflict = overlapping.docs.some((doc) => {
    const data = doc.data();
    const existingCheckOut = (data.checkOut as Timestamp).toDate();
    return existingCheckOut > checkInDate;
  });

  if (hasConflict) {
    throw new HttpsError('already-exists', 'Dates not available');
  }

  const nights = Math.ceil(
    (checkOutDate.getTime() - checkInDate.getTime()) / (1000 * 60 * 60 * 24)
  );
  const totalPrice = nights * acc.pricePerNight;
  const qrCode = uuid();

  const bookingRef = db.collection('bookings').doc();
  await bookingRef.set({
    userId: request.auth.uid,
    accommodationId,
    checkIn: Timestamp.fromDate(checkInDate),
    checkOut: Timestamp.fromDate(checkOutDate),
    guests,
    totalPrice,
    currency: acc.currency ?? 'USD',
    status: 'pending',
    qrCode,
    paymentId: null,
    receiptUrl: null,
    confirmedBy: null,
    createdAt: Timestamp.now(),
  });

  return { bookingId: bookingRef.id, qrCode, totalPrice };
});

export const confirmBooking = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Login required');

  const { bookingId } = request.data;
  const bookingRef = db.collection('bookings').doc(bookingId);
  const booking = await bookingRef.get();

  if (!booking.exists) throw new HttpsError('not-found', 'Booking not found');

  await bookingRef.update({
    status: 'confirmed',
    confirmedBy: 'admin',
  });

  return { success: true };
});

export const cancelBooking = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Login required');

  const { bookingId } = request.data;
  const bookingRef = db.collection('bookings').doc(bookingId);
  const booking = await bookingRef.get();

  if (!booking.exists) throw new HttpsError('not-found', 'Booking not found');

  const data = booking.data()!;
  if (data.userId !== request.auth.uid) {
    throw new HttpsError('permission-denied', 'Not your booking');
  }

  await bookingRef.update({ status: 'cancelled' });
  return { success: true };
});
