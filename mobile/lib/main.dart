import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/constants/app_config.dart';
import 'core/providers/locale_provider.dart';
import 'firebase_options.dart';

/// Top-level handler for background FCM messages (required by Firebase).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No-op: the notification is shown by the OS. We just need this registered
  // so Firebase doesn't drop background messages.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  if (AppConfig.devMode) {
    if (kDebugMode) {
      debugPrint('Firebase init skipped (dev mode)');
    }
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
      ],
      child: const AlaArchaApp(),
    ),
  );
}
