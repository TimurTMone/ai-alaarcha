import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../mocks/mock_data.dart';
import '../models/booking_model.dart';
import '../models/pass_model.dart';
import 'auth_provider.dart';

/// In-memory booking store for devMode. Survives provider rebuilds but not
/// hot-restarts — which is what we want while prototyping.
class DevBookingsNotifier extends StateNotifier<List<Booking>> {
  DevBookingsNotifier() : super(const []);

  void add(Booking booking) {
    state = [booking, ...state];
  }

  Booking? byId(String id) {
    for (final b in state) {
      if (b.id == id) return b;
    }
    return null;
  }

  void update(String id, Booking Function(Booking) transform) {
    state = [
      for (final b in state)
        if (b.id == id) transform(b) else b,
    ];
  }
}

final devBookingsProvider =
    StateNotifierProvider<DevBookingsNotifier, List<Booking>>(
  (ref) => DevBookingsNotifier(),
);

final userBookingsProvider = StreamProvider<List<Booking>>((ref) {
  if (AppConfig.devMode) {
    return Stream.value(ref.watch(devBookingsProvider));
  }
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(firestoreServiceProvider).watchUserBookings(user.uid);
});

final bookingByIdProvider =
    Provider.family<Booking?, String>((ref, id) {
  if (AppConfig.devMode) {
    final list = ref.watch(devBookingsProvider);
    for (final b in list) {
      if (b.id == id) return b;
    }
    return null;
  }
  final all = ref.watch(userBookingsProvider).valueOrNull ?? const [];
  for (final b in all) {
    if (b.id == id) return b;
  }
  return null;
});

final userPassesProvider = StreamProvider<List<ParkPass>>((ref) {
  if (AppConfig.devMode) return Stream.value(MockData.passes);
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(firestoreServiceProvider).watchUserPasses(user.uid);
});
