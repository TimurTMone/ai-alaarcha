import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/accommodation_model.dart';
import '../models/booking_model.dart';
import '../models/pass_model.dart';
import '../models/trail_model.dart';
import '../models/tour_model.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  // ── Users ──────────────────────────────────────────────────────────

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<void> createUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toFirestore());
  }

  Future<void> updateUserLanguage(String uid, String language) async {
    await _db.collection('users').doc(uid).update({'language': language});
  }

  // ── Accommodations ────────────────────────────────────────────────

  Stream<List<Accommodation>> watchAccommodations() {
    return _db
        .collection('accommodations')
        .snapshots()
        .map((snap) => snap.docs.map(Accommodation.fromFirestore).toList());
  }

  Future<Accommodation?> getAccommodation(String id) async {
    final doc = await _db.collection('accommodations').doc(id).get();
    if (!doc.exists) return null;
    return Accommodation.fromFirestore(doc);
  }

  // ── Bookings ──────────────────────────────────────────────────────

  Stream<List<Booking>> watchUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Booking.fromFirestore).toList());
  }

  Future<void> createBooking(Booking booking) async {
    await _db.collection('bookings').doc(booking.id).set(booking.toFirestore());
  }

  Future<void> updateBooking(
    String bookingId, {
    BookingStatus? status,
    String? receiptUrl,
    String? qrCode,
  }) async {
    final data = <String, Object>{};
    if (status != null) data['status'] = status.name;
    if (receiptUrl != null) data['receiptUrl'] = receiptUrl;
    if (qrCode != null) data['qrCode'] = qrCode;
    await _db.collection('bookings').doc(bookingId).update(data);
  }

  // ── Passes ────────────────────────────────────────────────────────

  Stream<List<ParkPass>> watchUserPasses(String userId) {
    return _db
        .collection('passes')
        .where('userId', isEqualTo: userId)
        .orderBy('validFrom', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ParkPass.fromFirestore).toList());
  }

  Future<void> createPass(ParkPass pass) async {
    await _db.collection('passes').doc(pass.id).set(pass.toFirestore());
  }

  // ── Trails ────────────────────────────────────────────────────────

  Stream<List<Trail>> watchTrails() {
    return _db
        .collection('trails')
        .snapshots()
        .map((snap) => snap.docs.map(Trail.fromFirestore).toList());
  }

  Future<Trail?> getTrail(String id) async {
    final doc = await _db.collection('trails').doc(id).get();
    if (!doc.exists) return null;
    return Trail.fromFirestore(doc);
  }

  // ── Tours ─────────────────────────────────────────────────────────

  Stream<List<Tour>> watchTours() {
    return _db
        .collection('tours')
        .snapshots()
        .map((snap) => snap.docs.map(Tour.fromFirestore).toList());
  }

  Future<Tour?> getTour(String id) async {
    final doc = await _db.collection('tours').doc(id).get();
    if (!doc.exists) return null;
    return Tour.fromFirestore(doc);
  }
}
