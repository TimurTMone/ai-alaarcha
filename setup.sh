#!/bin/bash
# Ala-Archa National Park - Project Setup Script
# Run this after cloning: ./setup.sh

set -e

echo "🏔  Ala-Archa Park - Setting up..."
echo ""

# 1. Firebase login
echo "Step 1: Firebase login"
firebase login
echo ""

# 2. Create Firebase project (or select existing)
echo "Step 2: Firebase project"
echo "Creating project 'ala-archa-park'..."
firebase projects:create ala-archa-park --display-name "Ala-Archa National Park" 2>/dev/null || echo "Project may already exist, continuing..."
firebase use ala-archa-park
echo ""

# 3. Enable Firebase services
echo "Step 3: Enabling Firebase services..."
firebase firestore:databases:create --location=europe-west1 2>/dev/null || echo "Firestore already enabled"
echo ""

# 4. FlutterFire configuration
echo "Step 4: Configuring Flutter Firebase..."
cd mobile
dart pub global activate flutterfire_cli 2>/dev/null || true
flutterfire configure --project=ala-archa-park --platforms=ios,android --ios-bundle-id=com.alaarchapark.alaArcha --android-package-name=com.alaarchapark.ala_archa
cd ..
echo ""

# 5. Deploy Firestore rules & indexes
echo "Step 5: Deploying Firestore rules & indexes..."
firebase deploy --only firestore:rules,firestore:indexes
echo ""

# 6. Deploy Storage rules
echo "Step 6: Deploying Storage rules..."
firebase deploy --only storage
echo ""

# 7. Build & deploy Cloud Functions
echo "Step 7: Building Cloud Functions..."
cd functions
npm run build
cd ..
firebase deploy --only functions
echo ""

# 8. Seed the database
echo "Step 8: Seeding database..."
cd functions
npx ts-node ../firestore/seed/seed.ts
cd ..
echo ""

# 9. Set secrets
echo "Step 9: Setting secrets..."
echo "Set your Anthropic API key:"
firebase functions:secrets:set ANTHROPIC_API_KEY
echo ""
echo "Set your Stripe secret key:"
firebase functions:secrets:set STRIPE_SECRET_KEY
echo ""

# 10. Copy env files
echo "Step 10: Creating .env files..."
cp web/.env.local.example web/.env.local
cp admin/.env.local.example admin/.env.local
echo "Edit web/.env.local and admin/.env.local with your Firebase config values"
echo "(Find them at: https://console.firebase.google.com/project/ala-archa-park/settings/general)"
echo ""

echo "✅ Setup complete!"
echo ""
echo "To run locally:"
echo "  Mobile:  cd mobile && flutter run"
echo "  Web:     cd web && npm run dev"
echo "  Admin:   cd admin && npm run dev"
echo "  Backend: firebase emulators:start"
