import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../mocks/mock_data.dart';
import '../models/booking_model.dart';
import '../models/pass_model.dart';
import 'auth_provider.dart';

final userBookingsProvider = StreamProvider<List<Booking>>((ref) {
  if (AppConfig.devMode) return Stream.value(const []);
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(firestoreServiceProvider).watchUserBookings(user.uid);
});

final userPassesProvider = StreamProvider<List<ParkPass>>((ref) {
  if (AppConfig.devMode) return Stream.value(MockData.passes);
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(firestoreServiceProvider).watchUserPasses(user.uid);
});
