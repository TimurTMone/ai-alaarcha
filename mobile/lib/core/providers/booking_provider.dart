import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../models/date_range.dart';
import '../mocks/mock_data.dart';
import '../models/booking_model.dart';
import '../models/pass_model.dart';
import 'auth_provider.dart';
import 'service_provider.dart';

/// In-memory booking store for devMode. Survives provider rebuilds but not
/// hot-restarts — which is what we want while prototyping.
class DevBookingsNotifier extends StateNotifier<List<Booking>> {
  DevBookingsNotifier() : super(const []);

  void add(Booking booking) {
    if (state.any((b) => b.id == booking.id)) {
      update(booking.id, (_) => booking);
      return;
    }
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

class DevPassesNotifier extends StateNotifier<List<ParkPass>> {
  DevPassesNotifier() : super(const []);

  void add(ParkPass pass) {
    if (state.any((p) => p.id == pass.id)) return;
    state = [pass, ...state];
  }

  void issueFromBooking(Booking booking) {
    final pass = passFromBooking(booking);
    if (pass != null) add(pass);
  }
}

final devBookingsProvider =
    StateNotifierProvider<DevBookingsNotifier, List<Booking>>(
      (ref) => DevBookingsNotifier(),
    );

final devPassesProvider =
    StateNotifierProvider<DevPassesNotifier, List<ParkPass>>(
      (ref) => DevPassesNotifier(),
    );

final allUserBookingsProvider = StreamProvider<List<Booking>>((ref) {
  if (AppConfig.useBackendBookings || AppConfig.devMode) {
    return Stream.value(ref.watch(devBookingsProvider));
  }
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(firestoreServiceProvider).watchUserBookings(user.uid);
});

final userBookingsProvider = StreamProvider<List<Booking>>((ref) {
  if (AppConfig.useBackendBookings || AppConfig.devMode) {
    return Stream.value(
      ref
          .watch(devBookingsProvider)
          .where((b) => b.subjectType != BookingSubject.pass)
          .toList(),
    );
  }
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref
      .watch(firestoreServiceProvider)
      .watchUserBookings(user.uid)
      .map(
        (bookings) => bookings
            .where((b) => b.subjectType != BookingSubject.pass)
            .toList(),
      );
});

final bookingByIdProvider = Provider.family<Booking?, String>((ref, id) {
  if (AppConfig.useBackendBookings || AppConfig.devMode) {
    final list = ref.watch(devBookingsProvider);
    for (final b in list) {
      if (b.id == id) return b;
    }
    return null;
  }
  final all = ref.watch(allUserBookingsProvider).valueOrNull ?? const [];
  for (final b in all) {
    if (b.id == id) return b;
  }
  return null;
});

final userPassesProvider = StreamProvider<List<ParkPass>>((ref) {
  if (AppConfig.devMode) {
    return Stream.value([...ref.watch(devPassesProvider), ...MockData.passes]);
  }
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(firestoreServiceProvider).watchUserPasses(user.uid);
});

ParkPass? passFromBooking(Booking booking) {
  if (booking.subjectType != BookingSubject.pass) return null;

  final parts = booking.subjectId.split(':');
  if (parts.length != 3 || parts.first != 'pass') return null;

  final type = _passTypeByName(parts[1]);
  final category = _passCategoryByName(parts[2]);
  if (type == null || category == null) return null;

  final validFrom = booking.startsAt ?? DateTime.now();
  final validTo = booking.endsAt ?? _defaultPassValidTo(type, validFrom);

  return ParkPass(
    id: 'pass-${booking.id}',
    userId: booking.userId,
    type: type,
    category: category,
    validFrom: validFrom,
    validTo: validTo,
    qrCode: booking.qrCode ?? 'ALAARCHA.PASS.${booking.id.toUpperCase()}',
    status: PassStatus.active,
    price: booking.totalPriceKgs.toDouble(),
    currency: booking.currency,
    paymentId: booking.paymentId ?? booking.id,
  );
}

PassType? _passTypeByName(String name) {
  for (final value in PassType.values) {
    if (value.name == name) return value;
  }
  return null;
}

PassCategory? _passCategoryByName(String name) {
  for (final value in PassCategory.values) {
    if (value.name == name) return value;
  }
  return null;
}

DateTime _defaultPassValidTo(PassType type, DateTime validFrom) {
  switch (type) {
    case PassType.day:
      return validFrom.add(const Duration(days: 1));
    case PassType.multiDay:
      return validFrom.add(const Duration(days: 3));
    case PassType.annual:
      return DateTime(validFrom.year + 1, validFrom.month, validFrom.day);
  }
}

// ── Availability ───────────────────────────────────────────────────────

/// Returns booked date ranges for a given service (subjectId).
/// A date range is "booked" if there's a booking with overlapping dates
/// in a live status (not cancelled/rejected).
final bookedRangesProvider = FutureProvider.family<List<DateRange>, String>((
  ref,
  serviceId,
) async {
  if (AppConfig.useBackendBookings) {
    return ref.watch(backendApiProvider).fetchBookedRanges(serviceId);
  }
  if (AppConfig.devMode) {
    // In devMode, derive from in-memory list.
    final all = ref.watch(devBookingsProvider);
    final ranges = _extractRanges(all, serviceId);
    return ranges;
  }

  // Firestore: query all bookings for this service that are live.
  return FirebaseFirestore.instance
      .collection('bookings')
      .where('subjectId', isEqualTo: serviceId)
      .where(
        'status',
        whereIn: [
          'pendingPayment',
          'pendingVerification',
          'needsReview',
          'approved',
          'checkedIn',
        ],
      )
      .snapshots()
      .map((snap) {
        final bookings = snap.docs.map(Booking.fromFirestore).toList();
        return _extractRanges(bookings, serviceId);
      })
      .first;
});

List<DateRange> _extractRanges(List<Booking> bookings, String serviceId) {
  return bookings
      .where(
        (b) =>
            b.subjectId == serviceId &&
            b.startsAt != null &&
            b.endsAt != null &&
            b.status != BookingStatus.cancelled &&
            b.status != BookingStatus.rejected,
      )
      .map((b) => DateRange(b.startsAt!, b.endsAt!))
      .toList();
}
