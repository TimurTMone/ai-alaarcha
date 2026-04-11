import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_config.dart';
import 'core/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/news/screens/news_detail_screen.dart';
import 'features/passes/screens/buy_pass_screen.dart';
import 'features/passes/screens/my_passes_screen.dart';
import 'features/ai_concierge/screens/chat_screen.dart';
import 'features/trails/screens/trails_map_screen.dart';
import 'features/trails/screens/trail_detail_screen.dart';
import 'features/tours/screens/tours_list_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/bookings/screens/booking_detail_screen.dart';
import 'features/bookings/screens/my_bookings_screen.dart';
import 'features/bookings/screens/payment_instructions_screen.dart';
import 'features/bookings/screens/receipt_upload_screen.dart';
import 'features/services/screens/service_detail_screen.dart';
import 'features/services/screens/service_booking_screen.dart';
import 'features/sos/screens/sos_screen.dart';
import 'shell_screen.dart';

final _rootNavigatorKey = fcmNavigatorKey;
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      if (AppConfig.devMode) {
        if (state.matchedLocation == '/login') return '/';
        return null;
      }

      final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/trails',
            builder: (context, state) => const TrailsMapScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => TrailDetailScreen(
                  trailId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const MyBookingsScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      // Full-screen routes (outside shell)
      GoRoute(
        path: '/passes/buy',
        builder: (context, state) => const BuyPassScreen(),
      ),
      GoRoute(
        path: '/passes',
        builder: (context, state) => const MyPassesScreen(),
      ),
      GoRoute(
        path: '/tours',
        builder: (context, state) => const ToursListScreen(),
      ),
      GoRoute(
        path: '/services/:id',
        builder: (context, state) =>
            ServiceDetailScreen(serviceId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'book',
            builder: (context, state) =>
                ServiceBookingScreen(serviceId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/news/:id',
        builder: (context, state) =>
            NewsDetailScreen(newsId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/bookings/:id',
        builder: (context, state) =>
            BookingDetailScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/bookings/:id/pay',
        builder: (context, state) => PaymentInstructionsScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/bookings/:id/receipt',
        builder: (context, state) => ReceiptUploadScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/sos',
        builder: (context, state) => const SOSScreen(),
      ),
    ],
  );
});
