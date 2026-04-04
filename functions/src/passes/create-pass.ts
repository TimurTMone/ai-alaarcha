import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { Timestamp } from 'firebase-admin/firestore';
import { v4 as uuid } from 'uuid';
import { db } from '../utils/admin';

const PRICES: Record<string, number> = {
  'day_citizen': 100,
  'day_tourist': 500,
  'day_child': 50,
  'day_student': 70,
  'multi_day_citizen': 250,
  'multi_day_tourist': 1200,
  'multi_day_child': 125,
  'multi_day_student': 175,
  'annual_citizen': 2000,
  'annual_tourist': 10000,
  'annual_child': 1000,
  'annual_student': 1400,
};

export const createPass = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Login required');

  const { type, category } = request.data;
  const priceKey = `${type}_${category}`;
  const price = PRICES[priceKey];

  if (!price) throw new HttpsError('invalid-argument', 'Invalid pass type');

  const now = new Date();
  const validTo = new Date(now);

  switch (type) {
    case 'day':
      validTo.setDate(validTo.getDate() + 1);
      break;
    case 'multi_day':
      validTo.setDate(validTo.getDate() + 3);
      break;
    case 'annual':
      validTo.setFullYear(validTo.getFullYear() + 1);
      break;
  }

  const qrCode = uuid();
  const passRef = db.collection('passes').doc();

  await passRef.set({
    userId: request.auth.uid,
    type,
    category,
    validFrom: Timestamp.fromDate(now),
    validTo: Timestamp.fromDate(validTo),
    qrCode,
    status: 'active',
    price,
    currency: 'KGS',
    paymentId: null,
    scannedAt: null,
    scannedBy: null,
  });

  return { passId: passRef.id, qrCode, price };
});

export const validatePass = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Login required');

  const { qrCode } = request.data;

  const snapshot = await db
    .collection('passes')
    .where('qrCode', '==', qrCode)
    .limit(1)
    .get();

  if (snapshot.empty) {
    return { valid: false, reason: 'Pass not found' };
  }

  const doc = snapshot.docs[0];
  const data = doc.data();
  const validTo = (data.validTo as Timestamp).toDate();
  const now = new Date();

  if (data.status !== 'active') {
    return { valid: false, reason: `Pass is ${data.status}` };
  }

  if (now > validTo) {
    await doc.ref.update({ status: 'expired' });
    return { valid: false, reason: 'Pass expired' };
  }

  // Mark as scanned
  await doc.ref.update({
    scannedAt: Timestamp.now(),
    scannedBy: request.auth.uid,
  });

  return { valid: true, passId: doc.id, userId: data.userId };
});
