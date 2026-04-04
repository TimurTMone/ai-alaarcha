import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, checkedIn, completed, cancelled }

class Booking {
  final String id;
  final String userId;
  final String accommodationId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String currency;
  final BookingStatus status;
  final String? qrCode;
  final String? paymentId;
  final String? receiptUrl;
  final String? confirmedBy;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.accommodationId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    this.currency = 'USD',
    this.status = BookingStatus.pending,
    this.qrCode,
    this.paymentId,
    this.receiptUrl,
    this.confirmedBy,
    required this.createdAt,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      userId: data['userId'] as String,
      accommodationId: data['accommodationId'] as String,
      checkIn: (data['checkIn'] as Timestamp).toDate(),
      checkOut: (data['checkOut'] as Timestamp).toDate(),
      guests: data['guests'] as int,
      totalPrice: (data['totalPrice'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'USD',
      status: BookingStatus.values.byName(data['status'] as String),
      qrCode: data['qrCode'] as String?,
      paymentId: data['paymentId'] as String?,
      receiptUrl: data['receiptUrl'] as String?,
      confirmedBy: data['confirmedBy'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  int get nightCount => checkOut.difference(checkIn).inDays;
}
