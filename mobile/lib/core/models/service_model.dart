import 'package:cloud_firestore/cloud_firestore.dart';

enum ServiceCategory { entrance, hotel, venue, recreation, rental, extra }

enum PriceUnit { perNight, perHour, perDay, perPerson, perTable, perItem, perVehicle, flat }

class Service {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final ServiceCategory category;
  final int priceKgs; // price in KGS (whole som)
  final PriceUnit unit;
  final int? capacity;
  final String? venue; // e.g. "Ala-Archa Hotel", "Ak-Bata"
  final List<String> images;
  final String? phone; // direct booking phone
  final bool isActive;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.priceKgs,
    required this.unit,
    this.capacity,
    this.venue,
    this.images = const [],
    this.phone,
    this.isActive = true,
  });

  factory Service.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Service(
      id: doc.id,
      name: Map<String, String>.from(data['name'] as Map),
      description: Map<String, String>.from(data['description'] as Map),
      category: ServiceCategory.values.byName(data['category'] as String),
      priceKgs: (data['priceKgs'] as num).toInt(),
      unit: PriceUnit.values.byName(data['unit'] as String),
      capacity: (data['capacity'] as num?)?.toInt(),
      venue: data['venue'] as String?,
      images: List<String>.from(data['images'] as List? ?? []),
      phone: data['phone'] as String?,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'category': category.name,
        'priceKgs': priceKgs,
        'unit': unit.name,
        if (capacity != null) 'capacity': capacity,
        if (venue != null) 'venue': venue,
        'images': images,
        if (phone != null) 'phone': phone,
        'isActive': isActive,
      };

  String localizedName(String locale) =>
      name[locale] ?? name['ru'] ?? name['en'] ?? '';

  String localizedDescription(String locale) =>
      description[locale] ?? description['ru'] ?? description['en'] ?? '';
}
