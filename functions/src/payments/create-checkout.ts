import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import Stripe from 'stripe';

const stripeSecret = defineSecret('STRIPE_SECRET_KEY');

export const createCheckout = onCall(
  { secrets: [stripeSecret] },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Login required');

    const { amount, currency, description, bookingId, bookingType } =
      request.data;

    const stripe = new Stripe(stripeSecret.value());

    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to smallest unit
      currency: currency.toLowerCase(),
      metadata: {
        userId: request.auth.uid,
        bookingId,
        bookingType,
      },
      description,
    });

    return {
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
    };
  }
);
