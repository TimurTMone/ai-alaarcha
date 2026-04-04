# TestFlight & App Store Deployment Guide

## Prerequisites

- [ ] Apple Developer Program membership ($99/yr) — https://developer.apple.com/programs/
- [ ] App Store Connect access — https://appstoreconnect.apple.com
- [ ] Firebase project fully configured (see PROJECT_PLAN.md Section 9, Phase 1)
- [ ] All 4 manual Firebase Console steps completed (see `pending_firebase_setup.md`)

## Pre-flight Checklist

### 1. Switch off dev mode
In `mobile/lib/core/constants/app_config.dart`:
```dart
static const bool devMode = false;
```

### 2. Configure real Firebase
```bash
cd mobile
flutterfire configure --project=ala-archa-park
```
This generates real `firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`.

### 3. Enable Apple Sign-In capability
In Xcode → Runner target → Signing & Capabilities → `+ Capability` → Sign in with Apple

### 4. Configure REVERSED_CLIENT_ID for Google Sign-In
From `GoogleService-Info.plist`, copy the `REVERSED_CLIENT_ID` value into `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>com.googleusercontent.apps.YOUR_ACTUAL_REVERSED_CLIENT_ID</string>
</array>
```

### 5. Set Apple Developer Team
In Xcode → Runner target → Signing & Capabilities → select your Team

### 6. Update version & build number
In `mobile/pubspec.yaml`:
```yaml
version: 1.0.0+1  # format: <semver>+<build-number>
```
Bump the build number for each TestFlight upload.

## App Store Connect Setup

### Create App Record
1. Go to https://appstoreconnect.apple.com
2. My Apps → `+` → New App
3. Fill in:
   - **Platform:** iOS
   - **Name:** Ala-Archa Park
   - **Primary Language:** Russian
   - **Bundle ID:** `com.alaarchapark.alaArcha` (must match Info.plist)
   - **SKU:** `ala-archa-park-ios-001`

### App Information
- **Subtitle:** Your gateway to the mountains
- **Category:** Travel (primary), Navigation (secondary)
- **Content Rights:** No third-party content
- **Age Rating:** 4+

### Privacy Policy URL
Required. Host at `alaarchapark.com/privacy` before submission.

### App Privacy
Declare data collection:
- **Location** → For navigation and SOS alerts
- **Contact Info (Email)** → For account management
- **Identifiers (User ID)** → For account management
- **Usage Data** → For analytics

## Build & Upload

### Option A: Xcode (recommended for first submission)
```bash
cd mobile
flutter build ipa --release
```
Then:
1. Open `build/ios/archive/Runner.xcarchive` in Xcode
2. Organizer → Distribute App → App Store Connect → Upload

### Option B: Command line
```bash
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
xcrun altool --upload-app -f build/ios/ipa/ala_archa.ipa \
  --apiKey YOUR_KEY_ID --apiIssuer YOUR_ISSUER_ID
```

## TestFlight Release

1. Wait ~30 min for Apple to process the build (you'll get an email)
2. Go to App Store Connect → TestFlight
3. Complete **Test Information** (required on first build):
   - What to test
   - Beta app description
   - Contact email
   - Privacy policy URL
4. Add **Internal Testers** (up to 100, no review needed):
   - TestFlight → Internal Group → + → add App Store Connect users
5. Add **External Testers** (up to 10,000, requires beta app review):
   - TestFlight → External Group → submit for review
   - Review typically takes 24-48 hours

## App Store Submission (when ready for production)

1. App Store Connect → App Store tab → Prepare for Submission
2. Upload screenshots (required sizes):
   - 6.9" (iPhone 17 Pro Max): 1320×2868
   - 6.5" (iPhone 11 Pro Max): 1242×2688
   - iPad: 2048×2732
3. App preview video (optional but recommended)
4. Fill in description, keywords, support URL
5. Select the uploaded build
6. Submit for review

## Common TestFlight Issues

| Issue | Fix |
|---|---|
| Build not showing up | Wait 30 min; check email for processing errors |
| "Invalid binary" | Usually missing ITSAppUsesNonExemptEncryption in Info.plist |
| "Missing Push Notification Entitlement" | Add Push capability in Xcode even if unused |
| Crash on launch | Real Firebase config missing — run `flutterfire configure` |

## Info.plist Additions Needed Before Upload

Add to `ios/Runner/Info.plist`:
```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```
(Declares app uses only standard HTTPS — skips encryption review.)
