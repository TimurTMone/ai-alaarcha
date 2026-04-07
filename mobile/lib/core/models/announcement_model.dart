import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final Map<String, String> title;
  final Map<String, String> body;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.createdAt,
    this.expiresAt,
  });

  String localizedTitle(String locale) =>
      title[locale] ?? title['ru'] ?? '';
  String localizedBody(String locale) =>
      body[locale] ?? body['ru'] ?? '';

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data()! as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: _localeMap(d['title']),
      body: _localeMap(d['body']),
      imageUrl: d['imageUrl'] as String?,
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      expiresAt: (d['expiresAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, String> _localeMap(dynamic raw) {
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {'ru': raw?.toString() ?? '', 'en': '', 'ky': ''};
  }
}
