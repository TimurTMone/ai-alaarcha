# Ala-Archa National Park — Super App 🏔

> AI-powered national park super-app for Ala-Archa, Kyrgyzstan. Entry passes, accommodations, gondola, tours, trail maps, and an AI concierge — all in one place.

Visit the park: [alaarchapark.com](https://alaarchapark.com)

---

## What's Inside

| Sub-project | Stack | Purpose |
|---|---|---|
| [`mobile/`](mobile/) | Flutter 3 + Riverpod + go_router | iOS & Android app for visitors |
| [`web/`](web/) | Next.js 15 + Tailwind + next-intl | Public marketing & booking website |
| [`admin/`](admin/) | Next.js 15 + Tailwind | Admin dashboard for staff |
| [`functions/`](functions/) | Firebase Cloud Functions + TypeScript | Backend logic, Claude AI, payments |
| [`firestore/`](firestore/) | Firestore rules, indexes, seed data | Database config |
| [`shared/`](shared/) | TypeScript types | Cross-project types & constants |

## Features

- 🎫 **QR-based entry passes** — buy online, scan at gate
- 🏔 **Accommodation booking** — A-frames, barnhouses, domes, cabins, mountain huts
- 🚡 **Gondola booking** — time slots with capacity & weather tracking
- 🤖 **AI Concierge "Archa"** — Claude-powered conversational booking
- 🥾 **Tour marketplace** — hiking, horse trekking, climbing, skiing, photography
- 🗺 **Trail maps** — GPS-enabled with offline support (Mapbox)
- 🍽 **Restaurant reservations**
- 💆 **Sauna & wellness booking**
- 🆘 **SOS emergency system** — GPS-based alerts to park rangers
- 🌐 **3 languages** — Russian (default), Kyrgyz, English — from day one

## Tech Stack

- **Mobile:** Flutter 3.41, Riverpod, go_router, Mapbox
- **Web & Admin:** Next.js 15, React 19, Tailwind, Shadcn/UI
- **Backend:** Firebase (Auth, Firestore, Functions, Storage, FCM, Hosting)
- **AI:** Claude API (`claude-sonnet-4-6`) with tool-use for booking actions
- **Payments:** Stripe + local (Mbank, O!Dengi, Balance.kg)
- **Auth:** Google Sign-In, Apple Sign-In, Phone OTP

## Getting Started

### Prerequisites
- Flutter 3.41+
- Node.js 20+
- Firebase CLI (`npm install -g firebase-tools`)

### One-command setup
```bash
./setup.sh
```

This will log you into Firebase, create the project, run `flutterfire configure`, deploy rules & indexes, deploy Cloud Functions, seed the database, and prompt for API secrets.

### Manual setup

1. **Firebase project** — create at [console.firebase.google.com](https://console.firebase.google.com/) and enable Firestore, Auth (Google + Apple), Storage, Functions (Blaze plan)

2. **Flutter Firebase config:**
   ```bash
   cd mobile
   flutterfire configure --project=your-project-id
   ```

3. **Deploy backend:**
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes,storage,functions
   ```

4. **Set secrets:**
   ```bash
   firebase functions:secrets:set ANTHROPIC_API_KEY
   firebase functions:secrets:set STRIPE_SECRET_KEY
   ```

5. **Seed database:**
   ```bash
   cd functions && npx ts-node ../firestore/seed/seed.ts
   ```

6. **Web env vars** — copy `web/.env.local.example` → `web/.env.local` and fill in values from Firebase Console. Same for `admin/`.

### Running locally

```bash
# Terminal 1 — Backend emulators
firebase emulators:start

# Terminal 2 — Mobile
cd mobile && flutter run

# Terminal 3 — Web
cd web && npm run dev

# Terminal 4 — Admin
cd admin && npm run dev
```

## Documentation

- **[PROJECT_PLAN.md](PROJECT_PLAN.md)** — Full architecture, data models, seed data, 14-week roadmap, i18n strategy
- **[CLAUDE.md](CLAUDE.md)** — Quick context for AI pair-programming sessions

## Project Structure

```
AiAlaArcha/
├── mobile/            # Flutter app
│   ├── lib/
│   │   ├── core/       # models, services, theme, providers
│   │   ├── features/   # auth, home, passes, accommodations, ai_concierge, ...
│   │   └── l10n/       # EN, RU, KY translations
│   └── pubspec.yaml
├── web/               # Next.js public site
├── admin/             # Next.js admin dashboard
├── functions/         # Firebase Cloud Functions
│   └── src/
│       ├── auth/       # User triggers
│       ├── bookings/   # Booking logic
│       ├── passes/     # Pass creation & QR validation
│       ├── ai/         # Claude API integration + tools
│       └── payments/   # Stripe integration
├── firestore/         # Rules, indexes, seed data
├── shared/            # Shared TypeScript types
├── firebase.json
└── setup.sh
```

## Internationalization

All user-facing text is in 3 languages from day one:
- **Flutter:** `gen-l10n` with ARB files — compile-time safe, no runtime overhead
- **Next.js:** `next-intl` with JSON message files + URL prefix routing (`/ru/`, `/en/`, `/ky/`)
- **Firestore content:** locale maps `{"en": "...", "ru": "...", "ky": "..."}` with fallback chain

See Section 12 of [PROJECT_PLAN.md](PROJECT_PLAN.md) for the full i18n architecture.

## License

Private project. All rights reserved.

---

*Built with ❤️ for the mountains of Kyrgyzstan*
