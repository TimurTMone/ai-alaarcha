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
  final String currency;

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
    this.currency = 'KGS',
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
      currency: data['currency'] as String? ?? 'KGS',
    );
  }

  factory Service.fromApi(Map<String, dynamic> json) {
    final category = _categoryFromSlug(
      (json['category'] as Map?)?['slug']?.toString(),
    );
    final image = json['image']?.toString();
    final gallery = (json['gallery'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => item['image']?.toString())
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .toList();
    final images = [
      if (image != null && image.isNotEmpty) image,
      ...gallery,
    ];
    final priceFrom = _toWholeSom(json['price_from']);
    final priceTo = _toWholeSom(json['price_to']);
    final name = json['name']?.toString() ?? '';
    final description = json['description']?.toString() ?? '';

    return Service(
      id: json['id'].toString(),
      name: {'ru': name, 'en': name, 'ky': name},
      description: {'ru': description, 'en': description, 'ky': description},
      category: category,
      priceKgs: priceFrom ?? priceTo ?? 0,
      unit: _unitFromBackend(json, category, description),
      capacity: (json['hotel_capacity'] as num?)?.toInt(),
      venue: (json['category'] as Map?)?['name']?.toString(),
      images: images,
      phone: json['phone']?.toString(),
      isActive: true,
      currency: json['price_currency']?.toString() ?? 'KGS',
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
        'currency': currency,
      };

  String localizedName(String locale) =>
      name[locale] ?? name['ru'] ?? name['en'] ?? '';

  String localizedDescription(String locale) =>
      description[locale] ?? description['ru'] ?? description['en'] ?? '';

  static ServiceCategory _categoryFromSlug(String? slug) {
    switch (slug) {
      case 'hotels':
      case 'a-frame':
        return ServiceCategory.hotel;
      case 'restaurants':
        return ServiceCategory.venue;
      case 'saunas':
        return ServiceCategory.recreation;
      case 'rentals':
        return ServiceCategory.rental;
      default:
        return ServiceCategory.extra;
    }
  }

  static PriceUnit _unitFromBackend(
    Map<String, dynamic> json,
    ServiceCategory category,
    String description,
  ) {
    final slug = (json['category'] as Map?)?['slug']?.toString() ?? '';
    final normalized = description.toLowerCase();
    if (slug == 'hotels' || slug == 'a-frame') return PriceUnit.perNight;
    if (normalized.contains('час') || normalized.contains('/ hour')) {
      return PriceUnit.perHour;
    }
    if (normalized.contains('чел') || normalized.contains('person')) {
      return PriceUnit.perPerson;
    }
    if (category == ServiceCategory.rental) return PriceUnit.perItem;
    return PriceUnit.flat;
  }

  static int? _toWholeSom(dynamic raw) {
    if (raw == null) return null;
    if (raw is num) return raw.round();
    return double.tryParse(raw.toString())?.round();
  }
}
