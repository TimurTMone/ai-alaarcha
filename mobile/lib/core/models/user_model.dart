import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { visitor, admin, staff, guide }

class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phone;
  final UserRole role;
  final String language;
  final DateTime createdAt;
  final DateTime? lastVisit;
  final List<String> fcmTokens;

  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phone,
    this.role = UserRole.visitor,
    this.language = 'ru',
    required this.createdAt,
    this.lastVisit,
    this.fcmTokens = const [],
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      phone: data['phone'] as String?,
      role: UserRole.values.byName(data['role'] as String? ?? 'visitor'),
      language: data['language'] as String? ?? 'ru',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastVisit: (data['lastVisit'] as Timestamp?)?.toDate(),
      fcmTokens: List<String>.from(data['fcmTokens'] as List? ?? []),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'phone': phone,
        'role': role.name,
        'language': language,
        'createdAt': Timestamp.fromDate(createdAt),
        'lastVisit': lastVisit != null ? Timestamp.fromDate(lastVisit!) : null,
        'fcmTokens': fcmTokens,
      };

  AppUser copyWith({
    String? displayName,
    String? photoUrl,
    String? phone,
    String? language,
    DateTime? lastVisit,
    List<String>? fcmTokens,
  }) =>
      AppUser(
        uid: uid,
        email: email,
        displayName: displayName ?? this.displayName,
        photoUrl: photoUrl ?? this.photoUrl,
        phone: phone ?? this.phone,
        role: role,
        language: language ?? this.language,
        createdAt: createdAt,
        lastVisit: lastVisit ?? this.lastVisit,
        fcmTokens: fcmTokens ?? this.fcmTokens,
      );
}
