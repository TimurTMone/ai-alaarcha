import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../mocks/mock_data.dart';
import '../services/auth_service.dart';
import '../services/fcm_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

final authStateProvider = StreamProvider<User?>((ref) {
  if (AppConfig.devMode) return Stream.value(null);
  return ref.watch(authServiceProvider).authStateChanges;
});

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  if (AppConfig.devMode) return MockData.devUser;

  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return null;

  final firestore = ref.read(firestoreServiceProvider);
  var appUser = await firestore.getUser(user.uid);

  if (appUser == null) {
    appUser = AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      phone: user.phoneNumber,
      createdAt: DateTime.now(),
    );
    await firestore.createUser(appUser);
  }

  return appUser;
});

/// Initializes FCM after auth. Watch this in a top-level widget to trigger.
final fcmInitProvider = FutureProvider<void>((ref) async {
  if (AppConfig.devMode) return;
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return;
  await FcmService.instance.init(
    userId: user.uid,
    navigatorKey: fcmNavigatorKey,
  );
});

/// The navigator key used by FCM to show snackbars and navigate on tap.
/// Assigned from the router's navigatorKey.
final fcmNavigatorKey = GlobalKey<NavigatorState>();
