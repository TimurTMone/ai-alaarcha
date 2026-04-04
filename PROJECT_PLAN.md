# Ala-Archa National Park - Super App
## Project Plan & Architecture Document

---

## 1. RESEARCH FINDINGS

### 1.1 Park Overview
- **Location:** Ala-Archa Gorge, 40km south of Bishkek, Kyrgyzstan
- **Size:** 20,000 hectares, elevation 1,600m - 4,875m
- **Open:** Year-round (peak season: late summer/early fall)
- **Existing website:** https://alaarchapark.com (pages: Home, About, News, SOS, Services, Booking, Map, Gallery, Contacts)
- **Contact:** +996 312 123456 | info@ala-archa.kg
- **Transport:** Electric buses run daily 8:00-19:00 from Bishkek

### 1.2 Current & Planned Facilities
| Facility | Status | Details |
|---|---|---|
| **Khan-Teniri Recreation Center** | Operational (expanding) | Barnhouses at $250/night, 5-star hotel under construction (ETA: summer 2026), glass terrace photo zone |
| **Cable Car / Gondola** | Operational | Ascends from park entrance to 3,200m+, panoramic Tien Shan views, free for barnhouse guests |
| **A-Frame Cabins** | Planned/Under Construction | Part of new tourist haven development |
| **Restaurant & Cafes** | Planned/Partial | Guest houses and restaurant at recreation center |
| **Swimming Pool** | Planned | Part of development project |
| **Saunas** | Planned | Part of recreation facilities |
| **Domed Structures** | Planned | Unique accommodation option |
| **Rasek Mountain Hut** | Operational | Base camp at 3,400m for alpinists |
| **ALTO Cabins** | Available | Mountain cabin accommodation |

### 1.3 Trails & Activities
- 150+ climbing and trekking routes (grades 1B to 6A)
- Key destinations: Ala-Archa Viewpoint (4.9/5), Chyngyz-Ata Peak (4.8/5), Ak-Sai River (4.7/5)
- Activities: hiking, horse trekking, skiing, mountain climbing, picnicking
- Trail status tracked on website (mostly open)

### 1.4 Digital Park App Benchmarks (US National Parks 2026)
- QR-based digital passes scanned at entrance
- Timed entry reservations via app
- Interactive offline maps with GPS
- Self-guided audio tours
- Real-time availability alerts for cancellations
- Campsite QR scan-and-pay (cashless)

---

## 2. PRODUCT VISION

### 2.1 Mission
Build the **first AI-powered national park super-app** for Ala-Archa that handles the entire visitor journey: discovery, booking, payment, entry, navigation, and post-visit engagement.

### 2.2 Core Value Propositions
1. **Frictionless Entry** - Buy park pass online, show QR at gate, walk in
2. **AI Concierge** - Conversational AI that helps book hotels, restaurants, tours in a natural, human way
3. **Smart Booking Engine** - Real-time availability for all accommodations (A-frames, Khan-Teniri, ALTO, barnhouses, domed structures)
4. **Trail Intelligence** - GPS-enabled trail maps with difficulty, weather, elevation, offline support
5. **Gondola Tickets** - Book cable car rides with time slots
6. **Tour Marketplace** - Book guided tours, horse treks, climbing expeditions
7. **SOS & Safety** - Emergency button with GPS location sharing
8. **Multi-language** - Kyrgyz, Russian, English

### 2.3 User Personas
| Persona | Needs |
|---|---|
| **Weekend Bishkek Family** | Easy entry pass, restaurant booking, gondola tickets, easy trails |
| **International Tourist** | Full booking (hotel + tours + entry), offline maps, English support |
| **Mountaineer/Climber** | Trail details, weather, Rasek hut booking, route grades, SOS |
| **Business/Event Group** | Venue booking, group rates, restaurant reservations |
| **Park Admin** | Dashboard, revenue tracking, capacity management, booking management |

---

## 3. FEATURES & MODULES

### 3.1 Mobile App (Flutter - iOS & Android)

#### Module 1: Onboarding & Auth
- Google Sign-In / Apple Sign-In
- Phone number auth (for local users)
- Language selection (KY/RU/EN)
- User profile with visit history

#### Module 2: Park Entry Pass
- Purchase day/multi-day pass
- Dynamic pricing (citizen vs tourist, weekday vs weekend)
- QR code generation (stored locally, works offline)
- Family/group passes
- QR scanner at gate (guard app)

#### Module 3: AI Concierge (Chat)
- Conversational booking assistant
- Flow: User asks -> AI shows availability -> User selects -> AI sends payment link -> User uploads receipt -> AI confirms -> QR code issued
- Powered by Claude API
- Context-aware: knows weather, availability, user history
- Supports text and voice input
- Multi-language responses

#### Module 4: Accommodation Booking
- **Khan-Teniri Barnhouses** - $250/night, includes gondola access
- **Khan-Teniri 5-Star Hotel** (when ready)
- **A-Frame Cabins**
- **ALTO Cabins**
- **Domed Structures**
- **Rasek Mountain Hut** (alpinist base camp)
- Calendar with real-time availability
- Photo galleries per property
- Reviews & ratings
- QR confirmation code

#### Module 5: Restaurant & Dining
- Browse menus
- Reserve tables with time slots
- Pre-order meals (for hikers returning)
- Special dietary filters

#### Module 6: Gondola / Cable Car
- Book time slots
- Live queue/wait indicator
- Included-with-stay indicator for barnhouse guests
- Weather-dependent availability
- Capacity tracking

#### Module 7: Tours & Activities
- Guided hiking tours
- Horse trekking expeditions
- Mountain climbing (with certified guides)
- Skiing tours (winter)
- Photography tours
- Book and pay in-app
- Guide profiles with ratings

#### Module 8: Trail Maps & Navigation
- Interactive map with all trails
- GPS tracking (works offline)
- Elevation profiles
- Difficulty ratings (1B-6A)
- Estimated time
- Points of interest along trail
- Weather overlay
- Trail condition updates (open/closed/caution)
- Download maps for offline use

#### Module 9: Sauna & Wellness
- Book sauna sessions
- Time slot selection
- Add-ons (private, group, with pool)

#### Module 10: SOS & Safety
- Emergency button (sends GPS to rescue)
- Park ranger contact
- Weather alerts
- Trail closure notifications
- First aid station locations

#### Module 11: Gallery & Social
- Photo spots with AR frames
- Share visit to social media
- Park news feed
- Events calendar

#### Module 12: Payments
- Credit/Debit cards (Stripe)
- Local payment methods (Mbank, O!Dengi, Balance.kg)
- Receipt upload for manual confirmation
- Refund management

### 3.2 Web App (Next.js)
- Marketing landing page
- Full booking flow (mirrors mobile)
- AI concierge chat widget
- Trail map explorer
- SEO-optimized content pages

### 3.3 Admin Dashboard (Next.js)
- **Overview** - Revenue, visitors today, occupancy rates, active bookings
- **Bookings Management** - All reservations, filter by type/status/date
- **Accommodation Manager** - Add/edit rooms, set pricing, block dates, manage availability
- **Entry Pass Manager** - Scan QR codes, view pass stats, set pricing tiers
- **Restaurant Manager** - Table management, reservation overview, menu editor
- **Gondola Manager** - Time slot config, capacity, weather override
- **Tour Manager** - Create tours, assign guides, manage schedules
- **AI Chat Monitor** - View conversations, intervene when needed, train responses
- **User Management** - View users, roles, ban/verify
- **Content Manager** - News, events, gallery, trail updates
- **Analytics** - Revenue reports, visitor trends, popular trails, booking conversion
- **SOS Dashboard** - Active emergencies, location tracking, response status
- **Settings** - Pricing rules, languages, notifications, park capacity

### 3.4 Guard/Staff App (Flutter - simplified)
- QR code scanner for entry validation
- Ticket/pass verification
- Manual entry override
- Headcount tracking

---

## 4. TECH STACK

### 4.1 Frontend
| Layer | Technology |
|---|---|
| Mobile App | Flutter 3.x (iOS + Android) |
| Web App | Next.js 15 (App Router) |
| Admin Dashboard | Next.js 15 + Shadcn/UI |
| State Management | Riverpod (Flutter) |
| Maps | Mapbox GL (offline support) |
| UI Components | Custom design system |

### 4.2 Backend (Firebase)
| Service | Usage |
|---|---|
| Firebase Auth | Google, Apple, Phone auth |
| Cloud Firestore | Primary database |
| Cloud Functions | Business logic, webhooks, AI orchestration |
| Cloud Storage | Images, documents, offline map tiles |
| Firebase Hosting | Web app & admin dashboard |
| Firebase Cloud Messaging | Push notifications |
| Firebase Analytics | Usage tracking |

### 4.3 AI Layer
| Service | Usage |
|---|---|
| Claude API (Anthropic) | AI concierge chat, booking assistant |
| Cloud Functions | AI orchestration, context management |

### 4.4 Payments
| Service | Usage |
|---|---|
| Stripe | International cards |
| Local integrations | Mbank, O!Dengi, Balance.kg APIs |

### 4.5 Infrastructure
| Service | Usage |
|---|---|
| Mapbox | Trail maps, GPS, offline tiles |
| Firebase Hosting | CDN for web |
| GitHub Actions | CI/CD |

---

## 5. DATA ARCHITECTURE

### 5.1 Firestore Collections

```
/users/{userId}
  - uid, email, displayName, photoUrl, phone
  - role: "visitor" | "admin" | "staff" | "guide"
  - language: "ky" | "ru" | "en"
  - createdAt, lastVisit
  - fcmTokens[]

/passes/{passId}
  - userId, type: "day" | "multi_day" | "annual"
  - category: "citizen" | "tourist" | "child" | "student"
  - validFrom, validTo
  - qrCode (encrypted string)
  - status: "active" | "used" | "expired" | "refunded"
  - price, currency, paymentId
  - scannedAt, scannedBy

/accommodations/{accommodationId}
  - name, type: "a_frame" | "barnhouse" | "hotel_room" | "cabin" | "dome" | "hut"
  - description: {ky, ru, en}
  - images[], amenities[]
  - capacity, pricePerNight, currency
  - location: GeoPoint
  - includesGondola: boolean
  - rating, reviewCount

/bookings/{bookingId}
  - userId, accommodationId
  - checkIn, checkOut
  - guests, totalPrice, currency
  - status: "pending" | "confirmed" | "checked_in" | "completed" | "cancelled"
  - qrCode, paymentId
  - receiptUrl (uploaded by user)
  - confirmedBy: "ai" | "admin"
  - createdAt

/restaurants/{restaurantId}
  - name, description: {ky, ru, en}
  - location: GeoPoint
  - images[], menuUrl
  - openingHours, capacity

/reservations/{reservationId}
  - userId, restaurantId
  - date, timeSlot, partySize
  - status: "reserved" | "seated" | "completed" | "no_show" | "cancelled"
  - specialRequests

/gondola_slots/{slotId}
  - date, time, capacity, booked
  - weatherStatus: "operational" | "delayed" | "closed"
  - pricePerPerson

/gondola_tickets/{ticketId}
  - userId, slotId
  - passengers, totalPrice
  - status: "booked" | "used" | "cancelled"
  - qrCode
  - includedWithStay: boolean

/tours/{tourId}
  - name, description: {ky, ru, en}
  - type: "hiking" | "horse" | "climbing" | "skiing" | "photo"
  - difficulty, duration, maxParticipants
  - price, currency
  - guideId, images[]
  - schedule[] (dates/times)
  - meetingPoint: GeoPoint

/tour_bookings/{bookingId}
  - userId, tourId, date
  - participants, totalPrice
  - status, qrCode, paymentId

/trails/{trailId}
  - name, description: {ky, ru, en}
  - difficulty: "1B" ... "6A"
  - distance, elevationGain, estimatedTime
  - coordinates[] (polyline)
  - pointsOfInterest[]
  - status: "open" | "caution" | "closed"
  - images[]

/sauna_sessions/{sessionId}
  - userId, saunaId
  - date, timeSlot, type: "private" | "group"
  - addOns[], totalPrice
  - status, qrCode

/chats/{chatId}
  - userId
  - messages[] (subcollection)
    - role: "user" | "assistant"
    - content, timestamp
    - bookingAction? (structured data for booking created)
  - status: "active" | "resolved"
  - handedToHuman: boolean

/payments/{paymentId}
  - userId, amount, currency
  - method: "stripe" | "mbank" | "odengi" | "balance_kg" | "receipt"
  - status: "pending" | "completed" | "failed" | "refunded"
  - receiptUrl, confirmedAt
  - relatedBookingType, relatedBookingId

/news/{newsId}
  - title: {ky, ru, en}
  - content: {ky, ru, en}
  - image, publishedAt, author

/sos_alerts/{alertId}
  - userId, location: GeoPoint
  - message, status: "active" | "responding" | "resolved"
  - createdAt, respondedBy, resolvedAt

/park_config/settings
  - entryPrices: {citizen, tourist, child, student}
  - parkCapacity, currentVisitors
  - operatingHours
  - weatherData
  - emergencyContacts
```

### 5.2 Security Rules Strategy
- Users can read/write their own data
- Admins can read/write everything
- Staff can scan and update passes/tickets
- Guides can view their assigned tours
- Public read for trails, accommodations, tours, restaurants, news
- Write-protected for bookings (only through Cloud Functions)

---

## 6. PROJECT STRUCTURE

```
AiAlaArcha/
├── CLAUDE.md                          # Claude context file
├── PROJECT_PLAN.md                    # This document
├── README.md                          # Project overview
│
├── mobile/                            # Flutter Mobile App
│   ├── android/
│   ├── ios/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   │   ├── app_colors.dart
│   │   │   │   ├── app_strings.dart    # i18n keys
│   │   │   │   ├── app_routes.dart
│   │   │   │   └── app_assets.dart
│   │   │   ├── theme/
│   │   │   │   ├── app_theme.dart
│   │   │   │   └── text_styles.dart
│   │   │   ├── utils/
│   │   │   │   ├── qr_generator.dart
│   │   │   │   ├── date_utils.dart
│   │   │   │   └── validators.dart
│   │   │   ├── services/
│   │   │   │   ├── auth_service.dart
│   │   │   │   ├── firestore_service.dart
│   │   │   │   ├── storage_service.dart
│   │   │   │   ├── payment_service.dart
│   │   │   │   ├── location_service.dart
│   │   │   │   ├── notification_service.dart
│   │   │   │   └── ai_chat_service.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   ├── pass_model.dart
│   │   │   │   ├── booking_model.dart
│   │   │   │   ├── accommodation_model.dart
│   │   │   │   ├── restaurant_model.dart
│   │   │   │   ├── reservation_model.dart
│   │   │   │   ├── gondola_model.dart
│   │   │   │   ├── tour_model.dart
│   │   │   │   ├── trail_model.dart
│   │   │   │   ├── sauna_model.dart
│   │   │   │   ├── chat_model.dart
│   │   │   │   ├── payment_model.dart
│   │   │   │   └── sos_model.dart
│   │   │   └── providers/
│   │   │       ├── auth_provider.dart
│   │   │       ├── booking_provider.dart
│   │   │       ├── accommodation_provider.dart
│   │   │       ├── pass_provider.dart
│   │   │       ├── trail_provider.dart
│   │   │       ├── chat_provider.dart
│   │   │       └── location_provider.dart
│   │   │
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── login_screen.dart
│   │   │   │   │   ├── signup_screen.dart
│   │   │   │   │   └── onboarding_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── social_login_button.dart
│   │   │   │       └── language_selector.dart
│   │   │   │
│   │   │   ├── home/
│   │   │   │   ├── screens/
│   │   │   │   │   └── home_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── weather_card.dart
│   │   │   │       ├── quick_actions.dart
│   │   │   │       ├── featured_places.dart
│   │   │   │       └── upcoming_bookings.dart
│   │   │   │
│   │   │   ├── passes/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── buy_pass_screen.dart
│   │   │   │   │   ├── my_passes_screen.dart
│   │   │   │   │   └── pass_qr_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── pass_card.dart
│   │   │   │       └── pricing_tier.dart
│   │   │   │
│   │   │   ├── accommodations/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── accommodations_list_screen.dart
│   │   │   │   │   ├── accommodation_detail_screen.dart
│   │   │   │   │   └── booking_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── accommodation_card.dart
│   │   │   │       ├── availability_calendar.dart
│   │   │   │       ├── amenity_chip.dart
│   │   │   │       └── review_card.dart
│   │   │   │
│   │   │   ├── ai_concierge/
│   │   │   │   ├── screens/
│   │   │   │   │   └── chat_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── chat_bubble.dart
│   │   │   │       ├── booking_action_card.dart
│   │   │   │       ├── receipt_upload.dart
│   │   │   │       └── voice_input_button.dart
│   │   │   │
│   │   │   ├── restaurant/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── restaurants_screen.dart
│   │   │   │   │   ├── restaurant_detail_screen.dart
│   │   │   │   │   └── reservation_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── menu_viewer.dart
│   │   │   │       └── time_slot_picker.dart
│   │   │   │
│   │   │   ├── gondola/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── gondola_screen.dart
│   │   │   │   │   └── gondola_booking_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── slot_picker.dart
│   │   │   │       └── queue_indicator.dart
│   │   │   │
│   │   │   ├── tours/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── tours_list_screen.dart
│   │   │   │   │   ├── tour_detail_screen.dart
│   │   │   │   │   └── tour_booking_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── tour_card.dart
│   │   │   │       └── guide_profile.dart
│   │   │   │
│   │   │   ├── trails/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── trails_map_screen.dart
│   │   │   │   │   └── trail_detail_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── trail_card.dart
│   │   │   │       ├── elevation_chart.dart
│   │   │   │       ├── difficulty_badge.dart
│   │   │   │       └── poi_marker.dart
│   │   │   │
│   │   │   ├── sauna/
│   │   │   │   ├── screens/
│   │   │   │   │   └── sauna_booking_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── session_card.dart
│   │   │   │
│   │   │   ├── sos/
│   │   │   │   ├── screens/
│   │   │   │   │   └── sos_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── emergency_button.dart
│   │   │   │
│   │   │   ├── profile/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── profile_screen.dart
│   │   │   │   │   └── booking_history_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── profile_menu.dart
│   │   │   │
│   │   │   └── notifications/
│   │   │       └── screens/
│   │   │           └── notifications_screen.dart
│   │   │
│   │   └── l10n/                       # Localization
│   │       ├── app_en.arb
│   │       ├── app_ru.arb
│   │       └── app_ky.arb
│   │
│   ├── assets/
│   │   ├── images/
│   │   ├── icons/
│   │   ├── fonts/
│   │   └── maps/                       # Offline map tiles
│   │
│   ├── test/
│   │   ├── unit/
│   │   ├── widget/
│   │   └── integration/
│   │
│   └── pubspec.yaml
│
├── web/                                # Next.js Web App
│   ├── src/
│   │   ├── app/
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx                # Landing page
│   │   │   ├── (auth)/
│   │   │   │   ├── login/page.tsx
│   │   │   │   └── signup/page.tsx
│   │   │   ├── book/
│   │   │   │   ├── page.tsx            # Booking hub
│   │   │   │   ├── stays/page.tsx
│   │   │   │   ├── gondola/page.tsx
│   │   │   │   ├── tours/page.tsx
│   │   │   │   └── restaurant/page.tsx
│   │   │   ├── passes/
│   │   │   │   └── page.tsx
│   │   │   ├── trails/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [trailId]/page.tsx
│   │   │   ├── chat/
│   │   │   │   └── page.tsx            # AI concierge
│   │   │   └── about/
│   │   │       └── page.tsx
│   │   ├── components/
│   │   │   ├── ui/                     # Shadcn components
│   │   │   ├── layout/
│   │   │   │   ├── header.tsx
│   │   │   │   ├── footer.tsx
│   │   │   │   └── nav.tsx
│   │   │   ├── booking/
│   │   │   ├── chat/
│   │   │   ├── maps/
│   │   │   └── shared/
│   │   ├── lib/
│   │   │   ├── firebase.ts
│   │   │   ├── auth.ts
│   │   │   ├── api.ts
│   │   │   └── utils.ts
│   │   ├── hooks/
│   │   ├── types/
│   │   └── styles/
│   ├── public/
│   ├── next.config.ts
│   ├── tailwind.config.ts
│   └── package.json
│
├── admin/                              # Admin Dashboard (Next.js)
│   ├── src/
│   │   ├── app/
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx                # Dashboard overview
│   │   │   ├── bookings/
│   │   │   │   └── page.tsx
│   │   │   ├── accommodations/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [id]/page.tsx
│   │   │   ├── passes/
│   │   │   │   └── page.tsx
│   │   │   ├── restaurant/
│   │   │   │   └── page.tsx
│   │   │   ├── gondola/
│   │   │   │   └── page.tsx
│   │   │   ├── tours/
│   │   │   │   └── page.tsx
│   │   │   ├── chat-monitor/
│   │   │   │   └── page.tsx
│   │   │   ├── users/
│   │   │   │   └── page.tsx
│   │   │   ├── content/
│   │   │   │   ├── news/page.tsx
│   │   │   │   ├── gallery/page.tsx
│   │   │   │   └── trails/page.tsx
│   │   │   ├── sos/
│   │   │   │   └── page.tsx
│   │   │   ├── analytics/
│   │   │   │   └── page.tsx
│   │   │   └── settings/
│   │   │       └── page.tsx
│   │   ├── components/
│   │   │   ├── ui/                     # Shadcn
│   │   │   ├── dashboard/
│   │   │   ├── data-tables/
│   │   │   └── charts/
│   │   ├── lib/
│   │   └── hooks/
│   └── package.json
│
├── functions/                          # Firebase Cloud Functions
│   ├── src/
│   │   ├── index.ts                    # Function exports
│   │   ├── auth/
│   │   │   └── on-user-create.ts       # New user setup
│   │   ├── bookings/
│   │   │   ├── create-booking.ts
│   │   │   ├── confirm-booking.ts
│   │   │   └── cancel-booking.ts
│   │   ├── passes/
│   │   │   ├── create-pass.ts
│   │   │   ├── validate-pass.ts        # QR validation
│   │   │   └── expire-passes.ts        # Scheduled
│   │   ├── payments/
│   │   │   ├── create-checkout.ts
│   │   │   ├── webhook-handler.ts
│   │   │   └── confirm-receipt.ts
│   │   ├── ai/
│   │   │   ├── chat-handler.ts         # Claude API integration
│   │   │   ├── booking-tools.ts        # AI function calling tools
│   │   │   └── system-prompt.ts        # AI concierge personality
│   │   ├── gondola/
│   │   │   └── manage-slots.ts
│   │   ├── notifications/
│   │   │   └── send-notification.ts
│   │   ├── sos/
│   │   │   └── handle-alert.ts
│   │   ├── scheduled/
│   │   │   ├── weather-sync.ts         # Fetch weather data
│   │   │   └── daily-reports.ts
│   │   └── utils/
│   │       ├── qr.ts
│   │       ├── email.ts
│   │       └── validators.ts
│   ├── package.json
│   └── tsconfig.json
│
├── firestore/
│   ├── firestore.rules
│   ├── firestore.indexes.json
│   └── seed/
│       ├── seed.ts                     # Seed script
│       ├── accommodations.json
│       ├── trails.json
│       ├── tours.json
│       ├── restaurants.json
│       ├── gondola-slots.json
│       └── park-config.json
│
├── storage/
│   └── storage.rules
│
├── shared/                             # Shared types/constants
│   ├── types/
│   │   ├── user.ts
│   │   ├── booking.ts
│   │   ├── accommodation.ts
│   │   ├── pass.ts
│   │   └── index.ts
│   └── constants/
│       ├── pricing.ts
│       └── enums.ts
│
├── firebase.json
├── .firebaserc
└── .github/
    └── workflows/
        ├── deploy-functions.yml
        ├── deploy-web.yml
        ├── deploy-admin.yml
        └── flutter-build.yml
```

---

## 7. AI CONCIERGE DESIGN

### 7.1 Conversation Flow Example

```
User: "Hi, I want to stay in the park this weekend with my family"

AI: "Welcome to Ala-Archa! I'd love to help you plan a family weekend.
    Let me check what's available for you.

    For this Saturday-Sunday (Apr 5-6), here's what I found:

    🏔 Khan-Teniri Barnhouse - $250/night (includes free gondola!)
       - Sleeps 4-6, mountain views, heated
    🏕 A-Frame Cabin - $120/night
       - Cozy 2-4 person cabin, forest setting
    🔵 Dome Stay - $90/night
       - Unique dome experience, fits 2-3

    Which catches your eye? Or tell me more about what you're looking for!"

User: "The A-Frame sounds perfect. Can we also do the gondola?"

AI: "Great choice! Let me set that up:

    📋 Your booking:
    • A-Frame Cabin - Apr 5-6 (1 night) - $120
    • Gondola ride - Apr 5, 11:00 AM (4 persons) - $40

    Total: $160

    How would you like to pay?
    1. Card (Visa/Mastercard)
    2. Mbank
    3. O!Dengi
    4. Bank transfer (upload receipt)

    Just pick a number!"
```

### 7.2 AI Tools (Function Calling)
The Claude AI concierge will have access to these tools:
- `check_availability(type, dates, guests)` - Check what's available
- `create_booking(accommodation_id, dates, guests)` - Create a booking
- `get_gondola_slots(date)` - Get available gondola times
- `book_gondola(slot_id, passengers)` - Book gondola tickets
- `reserve_restaurant(restaurant_id, date, time, party_size)` - Reserve table
- `get_trail_info(trail_id?)` - Get trail conditions and details
- `get_weather()` - Current and forecast weather
- `create_pass(type, category)` - Create entry pass
- `get_tours(date?, type?)` - Available tours
- `book_tour(tour_id, date, participants)` - Book a tour
- `get_user_bookings(user_id)` - User's active bookings
- `process_payment(booking_id, method)` - Initiate payment
- `confirm_receipt(booking_id, receipt_url)` - Confirm manual payment

### 7.3 System Prompt Personality
- Name: "Archa" (named after the park)
- Tone: Warm, knowledgeable, like a friendly local guide
- Languages: Responds in the user's language
- Context: Knows weather, trail conditions, availability in real-time
- Boundaries: Can book, but payments require user confirmation

---

## 8. SEED DATA

### 8.1 Accommodations
```json
[
  {
    "name": "Khan-Teniri Barnhouse A",
    "type": "barnhouse",
    "description": {"en": "Premium mountain barnhouse with panoramic views", "ru": "Премиум горный барнхаус с панорамным видом", "ky": "Тоо мензарасы менен премиум барнхаус"},
    "capacity": 6,
    "pricePerNight": 250,
    "currency": "USD",
    "amenities": ["wifi", "heating", "kitchen", "mountain_view", "parking"],
    "includesGondola": true,
    "images": ["barnhouse_a_1.jpg", "barnhouse_a_2.jpg"]
  },
  {
    "name": "Alpine A-Frame Cabin",
    "type": "a_frame",
    "description": {"en": "Cozy A-frame cabin nestled in the forest", "ru": "Уютный А-образный домик в лесу", "ky": "Токойдогу жайлуу А-формадагы үй"},
    "capacity": 4,
    "pricePerNight": 120,
    "currency": "USD",
    "amenities": ["heating", "fireplace", "kitchenette"],
    "includesGondola": false
  },
  {
    "name": "Mountain Dome",
    "type": "dome",
    "description": {"en": "Unique geodesic dome with stargazing ceiling", "ru": "Уникальный геодезический купол", "ky": "Жылдыздарды көрүүчү уникалдуу купол"},
    "capacity": 3,
    "pricePerNight": 90,
    "currency": "USD",
    "amenities": ["transparent_ceiling", "heating", "bed"],
    "includesGondola": false
  },
  {
    "name": "ALTO Mountain Cabin",
    "type": "cabin",
    "description": {"en": "Modern mountain cabin with all comforts", "ru": "Современная горная кабина", "ky": "Заманбап тоо кабинасы"},
    "capacity": 4,
    "pricePerNight": 150,
    "currency": "USD",
    "amenities": ["wifi", "heating", "kitchen", "hot_shower"],
    "includesGondola": false
  },
  {
    "name": "Rasek Mountain Hut",
    "type": "hut",
    "description": {"en": "Base camp hut at 3,400m for mountaineers", "ru": "Базовый лагерь на 3400м", "ky": "3400м бийиктиктеги базалык лагерь"},
    "capacity": 20,
    "pricePerNight": 25,
    "currency": "USD",
    "amenities": ["shared_bunks", "basic_kitchen"],
    "includesGondola": false
  }
]
```

### 8.2 Trails
```json
[
  {
    "name": {"en": "Ala-Archa Viewpoint Trail", "ru": "Тропа к смотровой площадке Ала-Арча", "ky": "Ала-Арча көрүнүш жолу"},
    "difficulty": "1B",
    "distance": 4.5,
    "elevationGain": 350,
    "estimatedTime": 120,
    "status": "open",
    "description": {"en": "Easy scenic walk to the park's most beautiful viewpoint. Family-friendly."}
  },
  {
    "name": {"en": "Ak-Sai Waterfall Trail", "ru": "Тропа к водопаду Ак-Сай", "ky": "Ак-Сай шаркыратма жолу"},
    "difficulty": "2A",
    "distance": 11,
    "elevationGain": 800,
    "estimatedTime": 300,
    "status": "open",
    "description": {"en": "Moderate hike to the stunning Ak-Sai glacier waterfall."}
  },
  {
    "name": {"en": "Chyngyz-Ata Peak", "ru": "Пик Чынгыз-Ата", "ky": "Чыңгыз-Ата чоку"},
    "difficulty": "3B",
    "distance": 8,
    "elevationGain": 1500,
    "estimatedTime": 480,
    "status": "open",
    "description": {"en": "Challenging ascent to one of the most popular peaks for mountaineers."}
  },
  {
    "name": {"en": "Ak-Sai Glacier Route", "ru": "Маршрут к леднику Ак-Сай", "ky": "Ак-Сай мөңгү жолу"},
    "difficulty": "4A",
    "distance": 14,
    "elevationGain": 2000,
    "estimatedTime": 600,
    "status": "caution",
    "description": {"en": "Advanced glacier approach. Requires proper equipment and experience."}
  },
  {
    "name": {"en": "Riverside Nature Walk", "ru": "Прогулка вдоль реки", "ky": "Дарыя боюнча жүрүш"},
    "difficulty": "1B",
    "distance": 3,
    "elevationGain": 100,
    "estimatedTime": 60,
    "status": "open",
    "description": {"en": "Gentle walk along Ak-Sai river. Perfect for families and relaxation."}
  }
]
```

### 8.3 Tours
```json
[
  {
    "name": {"en": "Guided Day Hike to Ak-Sai Waterfall", "ru": "Поход к водопаду Ак-Сай с гидом"},
    "type": "hiking",
    "difficulty": "moderate",
    "duration": 360,
    "maxParticipants": 12,
    "price": 35,
    "currency": "USD",
    "description": {"en": "Full-day guided hike to the Ak-Sai waterfall with lunch included."}
  },
  {
    "name": {"en": "Horse Trek Through the Valley", "ru": "Конная прогулка по долине"},
    "type": "horse",
    "difficulty": "easy",
    "duration": 180,
    "maxParticipants": 8,
    "price": 50,
    "currency": "USD"
  },
  {
    "name": {"en": "Sunrise Photography Tour", "ru": "Фототур на рассвете"},
    "type": "photo",
    "difficulty": "moderate",
    "duration": 240,
    "maxParticipants": 6,
    "price": 45,
    "currency": "USD"
  },
  {
    "name": {"en": "Alpine Climbing Introduction", "ru": "Введение в альпинизм"},
    "type": "climbing",
    "difficulty": "challenging",
    "duration": 480,
    "maxParticipants": 4,
    "price": 120,
    "currency": "USD"
  },
  {
    "name": {"en": "Winter Ski Touring", "ru": "Зимний скитур"},
    "type": "skiing",
    "difficulty": "moderate",
    "duration": 300,
    "maxParticipants": 6,
    "price": 80,
    "currency": "USD",
    "seasonal": "winter"
  }
]
```

### 8.4 Park Config
```json
{
  "entryPrices": {
    "citizen_adult": 100,
    "citizen_child": 50,
    "citizen_student": 70,
    "tourist_adult": 500,
    "tourist_child": 250,
    "tourist_student": 350,
    "currency": "KGS"
  },
  "parkCapacity": 2000,
  "operatingHours": {
    "summer": {"open": "06:00", "close": "21:00"},
    "winter": {"open": "07:00", "close": "18:00"}
  },
  "gondola": {
    "pricePerPerson": 500,
    "currency": "KGS",
    "operatingHours": {"open": "09:00", "close": "17:00"},
    "slotDuration": 30,
    "capacityPerSlot": 20
  },
  "emergencyContacts": {
    "parkRangers": "+996312123456",
    "mountainRescue": "+996312654321",
    "ambulance": "103",
    "police": "102"
  }
}
```

---

## 9. IMPLEMENTATION PHASES

### Phase 1: Foundation (Weeks 1-3)
- [ ] Firebase project setup (Auth, Firestore, Functions, Hosting)
- [ ] Flutter project scaffolding with folder structure
- [ ] Next.js web and admin projects setup
- [ ] Authentication (Google, Apple, Phone)
- [ ] Base data models and Firestore service
- [ ] Seed data script
- [ ] Basic navigation and routing (mobile + web)
- [ ] Design system / theme (colors, typography, components)
- [ ] i18n setup per Section 12 (gen-l10n for Flutter, next-intl for Web, locale maps in Firestore)

### Phase 2: Core Booking (Weeks 4-6)
- [ ] Entry pass purchase + QR generation
- [ ] QR scanner (guard app)
- [ ] Accommodation listing + detail views
- [ ] Booking flow with calendar
- [ ] Payment integration (Stripe)
- [ ] Booking confirmation + QR codes
- [ ] Admin: Bookings management dashboard

### Phase 3: AI Concierge (Weeks 7-8)
- [ ] Claude API integration via Cloud Functions
- [ ] Chat UI (mobile + web)
- [ ] AI tool definitions (check_availability, create_booking, etc.)
- [ ] System prompt + personality
- [ ] Receipt upload + AI confirmation flow
- [ ] Admin: Chat monitor

### Phase 4: Activities & Exploration (Weeks 9-11)
- [ ] Gondola booking with time slots
- [ ] Restaurant reservation system
- [ ] Tour marketplace + booking
- [ ] Sauna booking
- [ ] Trail map with GPS + offline support (Mapbox)
- [ ] Weather integration
- [ ] Admin: All activity management panels

### Phase 5: Safety & Engagement (Week 12)
- [ ] SOS emergency system
- [ ] Push notifications
- [ ] News feed
- [ ] Gallery
- [ ] Admin: SOS dashboard + analytics

### Phase 6: Polish & Launch (Weeks 13-14)
- [ ] Local payment integrations (Mbank, O!Dengi)
- [ ] Performance optimization
- [ ] Offline support (maps, passes)
- [ ] Testing (unit, widget, integration)
- [ ] App Store / Play Store submission
- [ ] Web deployment
- [ ] Admin training

---

## 10. DESIGN GUIDELINES

### 10.1 Brand Colors
- **Primary:** Deep Forest Green `#1B4332` (nature, park)
- **Secondary:** Mountain Gold `#D4A843` (warmth, premium)
- **Accent:** Sky Blue `#4DA8DA` (freshness, sky)
- **Background:** Snow White `#FAFBFC`
- **Surface:** Cloud Gray `#F0F2F5`
- **Text Primary:** `#1A1A2E`
- **Text Secondary:** `#6B7280`
- **Error/SOS:** `#DC2626`
- **Success:** `#059669`

### 10.2 Typography
- **Headings:** Inter Bold / Semi-Bold
- **Body:** Inter Regular
- **Numbers/Prices:** Inter Medium (tabular)

### 10.3 Design Principles
1. **Mountain-first** - Nature imagery, earthy tones, breathing space
2. **One-tap actions** - Critical flows in 3 taps max
3. **Offline-ready** - Core features work without connection
4. **Multi-language native** - Russian, Kyrgyz, English from day one. See Section 12 for full i18n architecture
5. **Accessibility** - WCAG 2.1 AA, large touch targets, contrast ratios

---

## 11. KEY DEPENDENCIES

### Flutter (pubspec.yaml)
```yaml
dependencies:
  flutter_riverpod: ^2.5
  firebase_core: ^3.0
  firebase_auth: ^5.0
  cloud_firestore: ^5.0
  firebase_storage: ^12.0
  firebase_messaging: ^15.0
  go_router: ^14.0
  mapbox_maps_flutter: ^2.0
  qr_flutter: ^4.1
  mobile_scanner: ^5.0     # QR scanning
  image_picker: ^1.0
  intl: ^0.19
  cached_network_image: ^3.3
  flutter_animate: ^4.5
  url_launcher: ^6.2
  geolocator: ^12.0
  dio: ^5.4
  shared_preferences: ^2.2
  path_provider: ^2.1
  connectivity_plus: ^6.0
```

### Web (package.json)
```json
{
  "dependencies": {
    "next": "^15",
    "react": "^19",
    "firebase": "^11",
    "tailwindcss": "^4",
    "@shadcn/ui": "latest",
    "mapbox-gl": "^3",
    "zustand": "^5",
    "react-hook-form": "^7",
    "zod": "^3",
    "date-fns": "^4",
    "recharts": "^2",
    "next-intl": "^4",
    "qrcode": "^1"
  }
}
```

---

## 12. INTERNATIONALIZATION (i18n) — FIRST-CLASS, NOT BOLTED ON

> **Rule: Every user-facing string must exist in all 3 languages from day one. No hardcoded text. Ever.**

### 12.1 Supported Languages
| Code | Language | Script | Direction | Primary Audience |
|---|---|---|---|---|
| `ru` | Russian | Cyrillic | LTR | Local visitors, CIS tourists |
| `ky` | Kyrgyz | Cyrillic | LTR | Local visitors, national identity |
| `en` | English | Latin | LTR | International tourists |

Default language: **Russian** (most park visitors are Russian-speaking). Auto-detected from device locale, manually switchable anywhere.

### 12.2 Architecture — How It Works Cleanly

#### Flutter (Mobile)
Use Flutter's built-in `gen-l10n` — zero bloat, compile-time safety.

```
lib/l10n/
  app_en.arb          ← source of truth
  app_ru.arb
  app_ky.arb
```

```dart
// app_en.arb
{
  "welcomeTitle": "Welcome to Ala-Archa",
  "bookNow": "Book Now",
  "trailDifficulty": "{difficulty} difficulty",
  "@trailDifficulty": {
    "placeholders": { "difficulty": { "type": "String" } }
  },
  "nightCount": "{count, plural, =1{1 night} other{{count} nights}}",
  "@nightCount": {
    "placeholders": { "count": { "type": "int" } }
  }
}
```

Usage — one line, type-safe, no magic strings:
```dart
Text(context.l10n.bookNow)
Text(context.l10n.nightCount(3))  // "3 nights"
```

Extension for clean access:
```dart
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

**No wrapper classes. No translation service singletons. The framework handles it.**

#### Next.js (Web + Admin)
Use `next-intl` — lightweight, SSR-compatible, type-safe.

```
web/src/
  messages/
    en.json
    ru.json
    ky.json
  i18n/
    request.ts          ← locale resolver
    routing.ts          ← /en/... /ru/... /ky/... URL prefixes
```

```typescript
// messages/en.json
{
  "home": {
    "welcome": "Welcome to Ala-Archa",
    "bookNow": "Book Now"
  },
  "booking": {
    "nights": "{count, plural, =1 {1 night} other {# nights}}"
  }
}
```

Usage:
```tsx
const t = useTranslations('home');
return <h1>{t('welcome')}</h1>;
```

URL structure: `alaarchapark.com/ru/book`, `alaarchapark.com/en/book`, `alaarchapark.com/ky/book`

#### Firestore (Backend Data)
All admin-managed content uses a locale map — simple, no extra collections:

```typescript
// Stored in Firestore
{
  "name": {
    "en": "Alpine A-Frame Cabin",
    "ru": "Альпийский А-образный домик",
    "ky": "Альпы А-формадагы үй"
  }
}

// Read in code — one helper, used everywhere
function localized(field: LocaleMap, locale: string): string {
  return field[locale] ?? field['ru'] ?? field['en'] ?? '';
}
```

Fallback chain: requested locale → Russian → English → empty string.

### 12.3 Translation Rules (For Clean Code)

1. **Never hardcode strings** — not in widgets, not in components, not in toasts, not in error messages
2. **ARB/JSON is the source of truth** — if a string isn't in the translation file, it doesn't belong in the UI
3. **Use ICU message syntax** for plurals, genders, selects — don't build strings with `if/else`
4. **Keep keys semantic** — `booking.confirmTitle`, not `text_42` or `confirm_button_label_v2`
5. **Group by feature** — `trails.difficulty`, `gondola.slotFull`, `sos.emergencyButton`
6. **Placeholders over concatenation** — `"Welcome, {name}"` not `welcome + " " + name`
7. **Admin dashboard is English-only** — staff-facing, no need to translate internal tools
8. **AI Concierge responds in the user's language** — detected from `user.language` field, Claude handles it natively

### 12.4 Translation Workflow
1. Developer adds key to `app_en.arb` (Flutter) or `en.json` (Web) with the English string
2. Corresponding keys added to `app_ru.arb` / `ru.json` and `app_ky.arb` / `ky.json`
3. CI checks: all keys must exist in all 3 files — build fails if a key is missing
4. Firestore content (accommodations, trails, tours, news) — admin enters all 3 languages in the dashboard

### 12.5 What NOT to Do
- Don't create a `TranslationService` singleton that loads strings at runtime
- Don't store translations in Firestore for UI strings (only for dynamic content like hotel names, trail descriptions)
- Don't use packages like `easy_localization` that add unnecessary runtime overhead when `gen-l10n` does it at compile time
- Don't duplicate locale logic — one `localized()` helper for Firestore data, one `context.l10n` for UI strings
- Don't translate programmatic values (enum names, IDs, routes)

### 12.6 Dependencies
```yaml
# Flutter — already built-in, just enable in pubspec.yaml
flutter:
  generate: true   # enables gen-l10n

# l10n.yaml (project root)
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

```json
// Web — one dependency
{ "next-intl": "^4" }
```

---

## 13. ENVIRONMENT VARIABLES

```env
# Firebase
FIREBASE_PROJECT_ID=ala-archa-park
FIREBASE_API_KEY=xxx
FIREBASE_AUTH_DOMAIN=ala-archa-park.firebaseapp.com

# Claude AI
ANTHROPIC_API_KEY=xxx

# Stripe
STRIPE_SECRET_KEY=xxx
STRIPE_PUBLISHABLE_KEY=xxx
STRIPE_WEBHOOK_SECRET=xxx

# Mapbox
MAPBOX_ACCESS_TOKEN=xxx

# Local Payments
MBANK_API_KEY=xxx
ODENGI_API_KEY=xxx

# App Config
NEXT_PUBLIC_APP_URL=https://alaarchapark.com
```

---

*Last updated: April 4, 2026*
*Version: 1.1 — Added Section 12: Internationalization architecture*
