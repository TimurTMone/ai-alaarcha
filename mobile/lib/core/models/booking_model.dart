import 'package:cloud_firestore/cloud_firestore.dart';
import 'service_model.dart';

enum BookingSubject { service, accommodation, pass, tour }

enum BookingStatus {
  pendingPayment,
  pendingVerification,
  needsReview,
  approved,
  rejected,
  checkedIn,
  completed,
  cancelled,
}

class AiVerification {
  final double score;
  final int? extractedAmountKgs;
  final DateTime? extractedDate;
  final String? extractedReference;
  final String? notes;

  const AiVerification({
    required this.score,
    this.extractedAmountKgs,
    this.extractedDate,
    this.extractedReference,
    this.notes,
  });

  factory AiVerification.fromMap(Map<String, dynamic> m) => AiVerification(
        score: (m['score'] as num).toDouble(),
        extractedAmountKgs: m['extractedAmountKgs'] as int?,
        extractedDate: (m['extractedDate'] as Timestamp?)?.toDate(),
        extractedReference: m['extractedReference'] as String?,
        notes: m['notes'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'score': score,
        if (extractedAmountKgs != null) 'extractedAmountKgs': extractedAmountKgs,
        if (extractedDate != null)
          'extractedDate': Timestamp.fromDate(extractedDate!),
        if (extractedReference != null) 'extractedReference': extractedReference,
        if (notes != null) 'notes': notes,
      };
}

class Booking {
  final String id;
  final String userId;

  // Discriminator
  final BookingSubject subjectType;
  final String subjectId;

  // For service bookings
  final PriceUnit? unit;
  final int quantity;

  // Date window (used by all types; accommodations use both, services may use one or both)
  final DateTime? startsAt;
  final DateTime? endsAt;

  // Kept for backward compat with existing accommodation flow
  final int guests;

  // Pricing — KGS in whole som (services use this)
  final int totalPriceKgs;
  final String currency;

  final BookingStatus status;
  final String? qrCode;
  final String? paymentId;
  final String? receiptUrl;
  final AiVerification? aiVerification;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.subjectType,
    required this.subjectId,
    this.unit,
    this.quantity = 1,
    this.startsAt,
    this.endsAt,
    this.guests = 1,
    required this.totalPriceKgs,
    this.currency = 'KGS',
    this.status = BookingStatus.pendingPayment,
    this.qrCode,
    this.paymentId,
    this.receiptUrl,
    this.aiVerification,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
    required this.createdAt,
  });

  /// Short human-readable reference users include in their bank memo.
  String get shortRef => id.length >= 6
      ? id.substring(0, 6).toUpperCase()
      : id.toUpperCase().padRight(6, '0');

  int get nightCount =>
      (startsAt != null && endsAt != null)
          ? endsAt!.difference(startsAt!).inDays
          : 0;

  /// Backwards-compat getter for old accommodation code paths.
  String get accommodationId =>
      subjectType == BookingSubject.accommodation ? subjectId : '';

  DateTime get checkIn => startsAt ?? createdAt;
  DateTime get checkOut => endsAt ?? createdAt;
  double get totalPrice => totalPriceKgs.toDouble();

  Booking copyWith({
    BookingStatus? status,
    String? qrCode,
    String? receiptUrl,
    AiVerification? aiVerification,
  }) =>
      Booking(
        id: id,
        userId: userId,
        subjectType: subjectType,
        subjectId: subjectId,
        unit: unit,
        quantity: quantity,
        startsAt: startsAt,
        endsAt: endsAt,
        guests: guests,
        totalPriceKgs: totalPriceKgs,
        currency: currency,
        status: status ?? this.status,
        qrCode: qrCode ?? this.qrCode,
        paymentId: paymentId,
        receiptUrl: receiptUrl ?? this.receiptUrl,
        aiVerification: aiVerification ?? this.aiVerification,
        reviewedBy: reviewedBy,
        reviewedAt: reviewedAt,
        rejectionReason: rejectionReason,
        createdAt: createdAt,
      );

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      userId: data['userId'] as String,
      subjectType: BookingSubject.values.byName(
        data['subjectType'] as String? ?? 'accommodation',
      ),
      subjectId:
          data['subjectId'] as String? ?? data['accommodationId'] as String? ?? '',
      unit: data['unit'] != null
          ? PriceUnit.values.byName(data['unit'] as String)
          : null,
      quantity: data['quantity'] as int? ?? 1,
      startsAt: (data['startsAt'] as Timestamp? ?? data['checkIn'] as Timestamp?)
          ?.toDate(),
      endsAt: (data['endsAt'] as Timestamp? ?? data['checkOut'] as Timestamp?)
          ?.toDate(),
      guests: data['guests'] as int? ?? 1,
      totalPriceKgs: (data['totalPriceKgs'] as num?)?.toInt() ??
          (data['totalPrice'] as num?)?.toInt() ??
          0,
      currency: data['currency'] as String? ?? 'KGS',
      status: BookingStatus.values.byName(data['status'] as String),
      qrCode: data['qrCode'] as String?,
      paymentId: data['paymentId'] as String?,
      receiptUrl: data['receiptUrl'] as String?,
      aiVerification: data['aiVerification'] != null
          ? AiVerification.fromMap(
              data['aiVerification'] as Map<String, dynamic>,
            )
          : null,
      reviewedBy: data['reviewedBy'] as String?,
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
      rejectionReason: data['rejectionReason'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'subjectType': subjectType.name,
        'subjectId': subjectId,
        if (unit != null) 'unit': unit!.name,
        'quantity': quantity,
        if (startsAt != null) 'startsAt': Timestamp.fromDate(startsAt!),
        if (endsAt != null) 'endsAt': Timestamp.fromDate(endsAt!),
        'guests': guests,
        'totalPriceKgs': totalPriceKgs,
        'currency': currency,
        'status': status.name,
        if (qrCode != null) 'qrCode': qrCode,
        if (paymentId != null) 'paymentId': paymentId,
        if (receiptUrl != null) 'receiptUrl': receiptUrl,
        if (aiVerification != null)
          'aiVerification': aiVerification!.toMap(),
        if (reviewedBy != null) 'reviewedBy': reviewedBy,
        if (reviewedAt != null) 'reviewedAt': Timestamp.fromDate(reviewedAt!),
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
