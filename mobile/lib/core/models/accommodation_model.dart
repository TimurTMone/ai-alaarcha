import 'package:cloud_firestore/cloud_firestore.dart';

enum AccommodationType { aFrame, barnhouse, hotelRoom, cabin, dome, hut }

class Accommodation {
  final String id;
  final String name;
  final AccommodationType type;
  final Map<String, String> description;
  final List<String> images;
  final List<String> amenities;
  final int capacity;
  final double pricePerNight;
  final String currency;
  final GeoPoint? location;
  final bool includesGondola;
  final String? bookingPhone;
  final double rating;
  final int reviewCount;

  const Accommodation({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.images = const [],
    this.amenities = const [],
    required this.capacity,
    required this.pricePerNight,
    this.currency = 'USD',
    this.location,
    this.includesGondola = false,
    this.bookingPhone,
    this.rating = 0,
    this.reviewCount = 0,
  });

  factory Accommodation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Accommodation(
      id: doc.id,
      name: data['name'] as String,
      type: AccommodationType.values.byName(data['type'] as String),
      description: Map<String, String>.from(data['description'] as Map),
      images: List<String>.from(data['images'] as List? ?? []),
      amenities: List<String>.from(data['amenities'] as List? ?? []),
      capacity: data['capacity'] as int,
      pricePerNight: (data['pricePerNight'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'USD',
      location: data['location'] as GeoPoint?,
      includesGondola: data['includesGondola'] as bool? ?? false,
      bookingPhone: data['bookingPhone'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: data['reviewCount'] as int? ?? 0,
    );
  }

  String localizedDescription(String locale) =>
      description[locale] ?? description['ru'] ?? description['en'] ?? '';
}
