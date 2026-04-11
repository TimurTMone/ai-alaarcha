import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final Map<String, String> title;
  final Map<String, String> body;
  final Map<String, String> content;
  final String? imageUrl;
  final String? categoryName;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.content,
    this.imageUrl,
    this.categoryName,
    required this.createdAt,
    this.expiresAt,
  });

  String localizedTitle(String locale) =>
      title[locale] ?? title['ru'] ?? '';
  String localizedBody(String locale) =>
      body[locale] ?? body['ru'] ?? '';
  String localizedContent(String locale) =>
      content[locale] ?? content['ru'] ?? localizedBody(locale);

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data()! as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: _localeMap(d['title']),
      body: _localeMap(d['body']),
      content: _localeMap(d['content'] ?? d['body']),
      imageUrl: d['imageUrl'] as String?,
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      expiresAt: (d['expiresAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Announcement.fromApi(Map<String, dynamic> json) {
    final title = json['title']?.toString() ?? '';
    final summary = json['summary']?.toString() ?? '';
    final content = json['content']?.toString() ?? summary;
    final publishedAt = json['published_at']?.toString();
    final createdAt = json['created_at']?.toString();

    return Announcement(
      id: json['id'].toString(),
      title: {'ru': title, 'en': title, 'ky': title},
      body: {
        'ru': summary.isNotEmpty ? summary : content,
        'en': summary.isNotEmpty ? summary : content,
        'ky': summary.isNotEmpty ? summary : content,
      },
      content: {
        'ru': content,
        'en': content,
        'ky': content,
      },
      imageUrl: json['image']?.toString(),
      categoryName: (json['category'] as Map?)?['name']?.toString(),
      createdAt: DateTime.tryParse(publishedAt ?? '') ??
          DateTime.tryParse(createdAt ?? '') ??
          DateTime.now(),
    );
  }

  static Map<String, String> _localeMap(dynamic raw) {
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {'ru': raw?.toString() ?? '', 'en': '', 'ky': ''};
  }
}
