import 'package:cloud_firestore/cloud_firestore.dart';
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

// ── Availability ───────────────────────────────────────────────────────

/// Returns booked date ranges for a given service (subjectId).
/// A date range is "booked" if there's a booking with overlapping dates
/// in a live status (not cancelled/rejected).
final bookedRangesProvider =
    StreamProvider.family<List<DateRange>, String>((ref, serviceId) {
  if (AppConfig.devMode) {
    // In devMode, derive from in-memory list.
    final all = ref.watch(devBookingsProvider);
    final ranges = _extractRanges(all, serviceId);
    return Stream.value(ranges);
  }

  // Firestore: query all bookings for this service that are live.
  return FirebaseFirestore.instance
      .collection('bookings')
      .where('subjectId', isEqualTo: serviceId)
      .where('status', whereIn: [
        'pendingPayment',
        'pendingVerification',
        'needsReview',
        'approved',
        'checkedIn',
      ])
      .snapshots()
      .map((snap) {
        final bookings = snap.docs.map(Booking.fromFirestore).toList();
        return _extractRanges(bookings, serviceId);
      });
});

List<DateRange> _extractRanges(List<Booking> bookings, String serviceId) {
  return bookings
      .where((b) =>
          b.subjectId == serviceId &&
          b.startsAt != null &&
          b.endsAt != null &&
          b.status != BookingStatus.cancelled &&
          b.status != BookingStatus.rejected)
      .map((b) => DateRange(b.startsAt!, b.endsAt!))
      .toList();
}

class DateRange {
  final DateTime start;
  final DateTime end;
  const DateRange(this.start, this.end);

  bool overlaps(DateTime checkIn, DateTime checkOut) {
    return checkIn.isBefore(end) && checkOut.isAfter(start);
  }

  /// Returns all individual dates that are "occupied" (check-in through
  /// day before check-out — standard hotel convention).
  List<DateTime> get occupiedDates {
    final dates = <DateTime>[];
    var d = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    while (d.isBefore(last)) {
      dates.add(d);
      d = d.add(const Duration(days: 1));
    }
    return dates;
  }
}
