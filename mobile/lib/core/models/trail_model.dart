import 'package:cloud_firestore/cloud_firestore.dart';

enum TrailStatus { open, caution, closed }

class Trail {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final String difficulty;
  final double distance;
  final int elevationGain;
  final int estimatedTimeMinutes;
  final TrailStatus status;
  final List<String> images;
  final List<GeoPoint> coordinates;

  const Trail({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.distance,
    required this.elevationGain,
    required this.estimatedTimeMinutes,
    this.status = TrailStatus.open,
    this.images = const [],
    this.coordinates = const [],
  });

  factory Trail.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Trail(
      id: doc.id,
      name: Map<String, String>.from(data['name'] as Map),
      description: Map<String, String>.from(data['description'] as Map),
      difficulty: data['difficulty'] as String,
      distance: (data['distance'] as num).toDouble(),
      elevationGain: data['elevationGain'] as int,
      estimatedTimeMinutes: data['estimatedTime'] as int,
      status: TrailStatus.values.byName(data['status'] as String),
      images: List<String>.from(data['images'] as List? ?? []),
      coordinates: (data['coordinates'] as List?)
              ?.map((c) => c as GeoPoint)
              .toList() ??
          [],
    );
  }

  String localizedName(String locale) =>
      name[locale] ?? name['ru'] ?? name['en'] ?? '';

  String localizedDescription(String locale) =>
      description[locale] ?? description['ru'] ?? description['en'] ?? '';

  bool get hasCoordinates => coordinates.isNotEmpty;

  GeoPoint? get startPoint => hasCoordinates ? coordinates.first : null;

  String get estimatedTimeFormatted {
    final hours = estimatedTimeMinutes ~/ 60;
    final minutes = estimatedTimeMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}
