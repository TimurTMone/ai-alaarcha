import 'package:cloud_firestore/cloud_firestore.dart';

enum PassType { day, multiDay, annual }

enum PassCategory { citizen, tourist, child, student }

enum PassStatus { active, used, expired, refunded }

class ParkPass {
  final String id;
  final String userId;
  final PassType type;
  final PassCategory category;
  final DateTime validFrom;
  final DateTime validTo;
  final String qrCode;
  final PassStatus status;
  final double price;
  final String currency;
  final String? paymentId;
  final DateTime? scannedAt;
  final String? scannedBy;

  const ParkPass({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.validFrom,
    required this.validTo,
    required this.qrCode,
    this.status = PassStatus.active,
    required this.price,
    this.currency = 'KGS',
    this.paymentId,
    this.scannedAt,
    this.scannedBy,
  });

  factory ParkPass.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return ParkPass(
      id: doc.id,
      userId: data['userId'] as String,
      type: PassType.values.byName(data['type'] as String),
      category: PassCategory.values.byName(data['category'] as String),
      validFrom: (data['validFrom'] as Timestamp).toDate(),
      validTo: (data['validTo'] as Timestamp).toDate(),
      qrCode: data['qrCode'] as String,
      status: PassStatus.values.byName(data['status'] as String),
      price: (data['price'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'KGS',
      paymentId: data['paymentId'] as String?,
      scannedAt: (data['scannedAt'] as Timestamp?)?.toDate(),
      scannedBy: data['scannedBy'] as String?,
    );
  }

  bool get isValid =>
      status == PassStatus.active && DateTime.now().isBefore(validTo);
}
