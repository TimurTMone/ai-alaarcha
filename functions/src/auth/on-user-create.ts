import * as functions from 'firebase-functions/v1';
import { db } from '../utils/admin';

export const onUserCreate = functions.auth.user().onCreate(async (user) => {
  await db.collection('users').doc(user.uid).set({
    email: user.email ?? null,
    displayName: user.displayName ?? null,
    photoUrl: user.photoURL ?? null,
    phone: user.phoneNumber ?? null,
    role: 'visitor',
    language: 'ru',
    createdAt: new Date(),
    lastVisit: null,
    fcmTokens: [],
  });
});
