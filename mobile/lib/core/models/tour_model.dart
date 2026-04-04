import 'package:cloud_firestore/cloud_firestore.dart';

enum TourType { hiking, horse, climbing, skiing, photo }

class Tour {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final TourType type;
  final String difficulty;
  final int durationMinutes;
  final int maxParticipants;
  final double price;
  final String currency;
  final String? guideId;
  final List<String> images;
  final GeoPoint? meetingPoint;

  const Tour({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.durationMinutes,
    required this.maxParticipants,
    required this.price,
    this.currency = 'USD',
    this.guideId,
    this.images = const [],
    this.meetingPoint,
  });

  factory Tour.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Tour(
      id: doc.id,
      name: Map<String, String>.from(data['name'] as Map),
      description: Map<String, String>.from(data['description'] as Map),
      type: TourType.values.byName(data['type'] as String),
      difficulty: data['difficulty'] as String,
      durationMinutes: data['duration'] as int,
      maxParticipants: data['maxParticipants'] as int,
      price: (data['price'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'USD',
      guideId: data['guideId'] as String?,
      images: List<String>.from(data['images'] as List? ?? []),
      meetingPoint: data['meetingPoint'] as GeoPoint?,
    );
  }

  String localizedName(String locale) =>
      name[locale] ?? name['ru'] ?? name['en'] ?? '';

  String localizedDescription(String locale) =>
      description[locale] ?? description['ru'] ?? description['en'] ?? '';

  String get durationFormatted {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}
