import 'package:cloud_firestore/cloud_firestore.dart';

enum ServiceCategory { hotel, venue, recreation, rental, extra }

enum PriceUnit { perNight, perHour, perDay, perPerson, perTable, perItem, flat }

class Service {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final ServiceCategory category;
  final int priceKgs; // price in KGS (whole som, not tiyin — display-only mock)
  final PriceUnit unit;
  final int? capacity;
  final String? venue; // e.g. "Ala-Archa Hotel", "Ak-Bata"

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.priceKgs,
    required this.unit,
    this.capacity,
    this.venue,
  });

  factory Service.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Service(
      id: doc.id,
      name: Map<String, String>.from(data['name'] as Map),
      description: Map<String, String>.from(data['description'] as Map),
      category: ServiceCategory.values.byName(data['category'] as String),
      priceKgs: data['priceKgs'] as int,
      unit: PriceUnit.values.byName(data['unit'] as String),
      capacity: data['capacity'] as int?,
      venue: data['venue'] as String?,
    );
  }

  String localizedName(String locale) =>
      name[locale] ?? name['ru'] ?? name['en'] ?? '';

  String localizedDescription(String locale) =>
      description[locale] ?? description['ru'] ?? description['en'] ?? '';
}
