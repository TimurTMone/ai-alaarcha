# Ala-Archa National Park Super App

## Project Overview
AI-powered national park super-app for Ala-Archa National Park, Kyrgyzstan. Handles the full visitor journey: discovery, booking, payment (QR-based entry), AI concierge, trail navigation, and emergency services.

## Tech Stack
- **Mobile:** Flutter 3.x (iOS + Android) with Riverpod
- **Web App:** Next.js 15 (App Router) + Tailwind + Shadcn/UI
- **Admin Dashboard:** Next.js 15 + Shadcn/UI
- **Backend:** Firebase (Auth, Firestore, Cloud Functions, Storage, Hosting, FCM)
- **AI:** Claude API (Anthropic) for conversational booking concierge
- **Maps:** Mapbox GL with offline support
- **Payments:** Stripe + local (Mbank, O!Dengi, Balance.kg)
- **Auth:** Google Sign-In, Apple Sign-In, Phone auth
- **Languages:** English, Russian, Kyrgyz

## Project Structure
- `mobile/` - Flutter app (features-first architecture)
- `web/` - Next.js public-facing web app
- `admin/` - Next.js admin dashboard
- `functions/` - Firebase Cloud Functions (TypeScript)
- `firestore/` - Firestore rules, indexes, seed data
- `shared/` - Shared TypeScript types and constants
- `storage/` - Firebase Storage rules

## Key Features
1. QR-based park entry passes (buy online, scan at gate)
2. AI Concierge "Archa" - conversational booking via Claude API
3. Accommodation booking (Khan-Teniri barnhouses, A-frames, domes, cabins, mountain hut)
4. Gondola/cable car time-slot booking
5. Restaurant reservations
6. Tour marketplace (hiking, horse, climbing, skiing, photo)
7. GPS trail maps with offline support
8. Sauna/wellness booking
9. SOS emergency system
10. Admin dashboard with analytics

## Architecture Decisions
- Feature-first folder structure in Flutter (`features/{name}/screens/`, `features/{name}/widgets/`)
- Shared core layer: `core/models/`, `core/services/`, `core/providers/`
- All bookings go through Cloud Functions (not direct Firestore writes)
- AI concierge uses Claude tool_use for booking actions
- QR codes contain encrypted pass/booking IDs validated server-side
- Multilingual: all user-facing strings use i18n ARB files (Flutter gen-l10n) and next-intl (Web)

## Internationalization (Critical)
- **3 languages: Russian (default), Kyrgyz, English** — every string, from day one
- **Flutter:** `gen-l10n` with ARB files. Access via `context.l10n.keyName`. No third-party i18n packages.
- **Next.js:** `next-intl` with JSON message files. URL prefix routing (`/ru/`, `/en/`, `/ky/`).
- **Firestore content:** locale map `{"en": "...", "ru": "...", "ky": "..."}` with `localized(field, locale)` helper.
- **Never hardcode strings.** No concatenation for translated text. Use ICU placeholders and plurals.
- **Admin dashboard is English-only** (staff-facing).
- See PROJECT_PLAN.md Section 12 for full architecture and rules.

## Conventions
- Dart: snake_case files, PascalCase classes
- TypeScript: camelCase variables, PascalCase types/interfaces
- Firestore: snake_case collection names, camelCase field names
- All prices stored in smallest currency unit (tiyin for KGS, cents for USD)
- Dates stored as Firestore Timestamps
- All API responses follow `{success: boolean, data?: T, error?: string}` pattern

## Detailed Plan
See PROJECT_PLAN.md for full architecture, data models, seed data, phases, and design guidelines.
