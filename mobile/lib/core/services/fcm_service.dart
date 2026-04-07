import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// Handles FCM token registration, permission prompting, and foreground
/// message display. Call [init] once after Firebase.initializeApp + auth.
class FcmService {
  FcmService._();
  static final instance = FcmService._();

  final _messaging = FirebaseMessaging.instance;

  /// Call after the user is authenticated. Requests permission, syncs token
  /// to Firestore, and listens for foreground messages.
  Future<void> init({
    required String userId,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    // 1. Request permission (iOS shows a system dialog, Android auto-grants).
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      if (kDebugMode) debugPrint('FCM: permission denied');
      return;
    }

    // 2. Get token and store it.
    final token = await _messaging.getToken();
    if (token != null) {
      await _syncToken(userId, token);
    }

    // 3. Listen for token refreshes.
    _messaging.onTokenRefresh.listen((newToken) {
      _syncToken(userId, newToken);
    });

    // 4. Foreground messages → show a snackbar / local notification.
    FirebaseMessaging.onMessage.listen((message) {
      _showForegroundMessage(message, navigatorKey);
    });

    // 5. Tap on notification while app is in background → navigate.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleTap(message, navigatorKey);
    });

    // 6. Check if app was opened from a terminated-state notification.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _handleTap(initial, navigatorKey);
    }
  }

  /// Adds the token to the user's `fcmTokens` array (deduped by arrayUnion).
  Future<void> _syncToken(String userId, String token) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
      if (kDebugMode) debugPrint('FCM: token synced');
    } catch (e) {
      if (kDebugMode) debugPrint('FCM: token sync failed: $e');
    }
  }

  void _showForegroundMessage(
    RemoteMessage message,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    final notification = message.notification;
    if (notification == null) return;

    final context = navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (notification.body != null) Text(notification.body!),
          ],
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: '→',
          onPressed: () => _handleTap(message, navigatorKey),
        ),
      ),
    );
  }

  void _handleTap(
    RemoteMessage message,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    final data = message.data;
    final type = data['type'] as String?;
    final bookingId = data['bookingId'] as String?;

    if (type == 'booking_status' && bookingId != null) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        GoRouter.of(context).push('/bookings/$bookingId');
      }
    }
  }
}
