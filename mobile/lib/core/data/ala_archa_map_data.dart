import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

typedef LocalizedText = Map<String, String>;

enum AlaArchaFeatureCategory {
  trailhead,
  waterfall,
  hut,
  viewpoint,
  attraction,
  peak,
  memorial,
}

enum AlaArchaRouteDifficulty { easy, moderate, hard }

class AlaArchaMapFeature {
  const AlaArchaMapFeature({
    required this.id,
    required this.category,
    required this.name,
    required this.summary,
    required this.position,
    this.elevationMeters,
    this.source = 'OpenStreetMap',
  });

  final String id;
  final AlaArchaFeatureCategory category;
  final LocalizedText name;
  final LocalizedText summary;
  final LatLng position;
  final int? elevationMeters;
  final String source;
}

class AlaArchaMapRoute {
  const AlaArchaMapRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.distanceKm,
    required this.destinationId,
    required this.path,
  });

  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final AlaArchaRouteDifficulty difficulty;
  final double distanceKm;
  final String destinationId;
  final List<LatLng> path;
}

abstract final class AlaArchaMapData {
  static const defaultCenter = LatLng(42.56234, 74.48242);

  static final bounds = LatLngBounds(
    const LatLng(42.5218, 74.4805),
    const LatLng(42.5914, 74.5475),
  );

  static const features = <AlaArchaMapFeature>[
    AlaArchaMapFeature(
      id: 'alplager',
      category: AlaArchaFeatureCategory.trailhead,
      name: {
        'en': 'Alplager trailhead',
        'ru': 'Альплагерь',
        'ky': 'Альплагерь',
      },
      summary: {
        'en': 'Main trailhead for the Ak-Sai valley routes.',
        'ru': 'Главная точка старта маршрутов в ущелье Ак-Сай.',
        'ky': 'Ак-Сай өрөөнүндөгү маршруттардын негизги башталышы.',
      },
      position: LatLng(42.5623368, 74.4824238),
      elevationMeters: 2160,
    ),
    AlaArchaMapFeature(
      id: 'broken-heart',
      category: AlaArchaFeatureCategory.attraction,
      name: {
        'en': 'Broken Heart Rock',
        'ru': 'Камень «Разбитое сердце»',
        'ky': '«Сынган жүрөк» ташы',
      },
      summary: {
        'en': 'Short scenic climb from Alplager.',
        'ru': 'Короткий видовой подъём от альплагеря.',
        'ky': 'Альплагерден кыска көрүнүштүү көтөрүлүү.',
      },
      position: LatLng(42.5558306, 74.4926035),
      elevationMeters: 2415,
    ),
    AlaArchaMapFeature(
      id: 'panorama-broken-heart',
      category: AlaArchaFeatureCategory.viewpoint,
      name: {
        'en': 'Panoramic viewpoint',
        'ru': 'Панорамный вид у «Разбитого сердца»',
        'ky': '«Сынган жүрөк» жанындагы панорама',
      },
      summary: {
        'en': 'Viewpoint above the Ak-Sai valley.',
        'ru': 'Смотровая точка над долиной Ак-Сай.',
        'ky': 'Ак-Сай өрөөнүнүн үстүндөгү көрүү жери.',
      },
      position: LatLng(42.5558797, 74.4925520),
      elevationMeters: 2415,
    ),
    AlaArchaMapFeature(
      id: 'ratsek-hut',
      category: AlaArchaFeatureCategory.hut,
      name: {'en': 'Ratsek Hut', 'ru': 'Хижина Рацека', 'ky': 'Рацека үйү'},
      summary: {
        'en': 'Classic high-mountain hut on the Ak-Sai approach.',
        'ru': 'Классическая высокогорная хижина на подходе к Ак-Саю.',
        'ky': 'Ак-Сай багытындагы бийик тоодогу белгилүү үй.',
      },
      position: LatLng(42.5349125, 74.5286827),
      elevationMeters: 3300,
    ),
    AlaArchaMapFeature(
      id: 'komsomolets',
      category: AlaArchaFeatureCategory.peak,
      name: {
        'en': 'Komsomolets Peak',
        'ru': 'Пик Комсомолец',
        'ky': 'Комсомолец чокусу',
      },
      summary: {
        'en': 'Demanding alpine route. Guide and equipment required.',
        'ru': 'Сложный альпинистский маршрут. Нужны гид и снаряжение.',
        'ky': 'Татаал альпинисттик маршрут. Гид жана шайман керек.',
      },
      position: LatLng(42.5699063, 74.5474168),
      elevationMeters: 4204,
    ),
    AlaArchaMapFeature(
      id: 'tepshi',
      category: AlaArchaFeatureCategory.viewpoint,
      name: {'en': 'Tepshi Plateau', 'ru': 'Плато Тепши', 'ky': 'Тепши сырты'},
      summary: {
        'en': 'Open plateau with views over the side valley.',
        'ru': 'Открытое плато с видом на боковое ущелье.',
        'ky': 'Каптал капчыгайга көрүнгөн ачык плато.',
      },
      position: LatLng(42.5560866, 74.5011096),
      elevationMeters: 2580,
    ),
  ];

  static const routes = <AlaArchaMapRoute>[
    AlaArchaMapRoute(
      id: 't1',
      name: {
        'en': 'Broken Heart Viewpoint',
        'ru': 'Камень «Разбитое сердце»',
        'ky': '«Сынган жүрөк» жолу',
      },
      description: {
        'en': 'Short real OSM trail from Alplager to the viewpoint.',
        'ru': 'Короткая реальная OSM-тропа от альплагеря к смотровой.',
        'ky': 'Альплагерден көрүү жерине чейинки кыска OSM жолу.',
      },
      difficulty: AlaArchaRouteDifficulty.easy,
      distanceKm: 2.2,
      destinationId: 'broken-heart',
      path: [
        LatLng(42.5623368, 74.4824238),
        LatLng(42.5611886, 74.4831520),
        LatLng(42.5606355, 74.4838178),
        LatLng(42.5600949, 74.4841966),
        LatLng(42.5593404, 74.4840175),
        LatLng(42.5587892, 74.4845645),
        LatLng(42.5583184, 74.4852059),
        LatLng(42.5573085, 74.4870223),
        LatLng(42.5562464, 74.4878945),
        LatLng(42.5555385, 74.4892633),
        LatLng(42.5553008, 74.4910262),
        LatLng(42.5558306, 74.4926035),
      ],
    ),
    AlaArchaMapRoute(
      id: 't2',
      name: {
        'en': 'Ak-Sai Valley to Ratsek Hut',
        'ru': 'Долина Ак-Сай до хижины Рацека',
        'ky': 'Ак-Сай өрөөнү - Рацека үйү',
      },
      description: {
        'en': 'Main hiking line from Alplager toward Ratsek Hut.',
        'ru': 'Основная тропа от альплагеря к хижине Рацека.',
        'ky': 'Альплагерден Рацека үйүнө негизги жол.',
      },
      difficulty: AlaArchaRouteDifficulty.moderate,
      distanceKm: 8.8,
      destinationId: 'ratsek-hut',
      path: [
        LatLng(42.5623368, 74.4824238),
        LatLng(42.5600949, 74.4841966),
        LatLng(42.5573085, 74.4870223),
        LatLng(42.5558306, 74.4926035),
        LatLng(42.5559975, 74.4926586),
        LatLng(42.5562855, 74.4955819),
        LatLng(42.5568442, 74.4974890),
        LatLng(42.5557239, 74.5023599),
        LatLng(42.5524132, 74.5077139),
        LatLng(42.5505896, 74.5110583),
        LatLng(42.5473609, 74.5155618),
        LatLng(42.5441784, 74.5170504),
        LatLng(42.5414582, 74.5185940),
        LatLng(42.5385341, 74.5206868),
        LatLng(42.5362052, 74.5258031),
        LatLng(42.5358654, 74.5254730),
        LatLng(42.5348047, 74.5284811),
        LatLng(42.5349125, 74.5286827),
      ],
    ),
    AlaArchaMapRoute(
      id: 't3',
      name: {
        'en': 'Komsomolets Peak Approach',
        'ru': 'Подход к пику Комсомолец',
        'ky': 'Комсомолец чокусуна жол',
      },
      description: {
        'en': 'Hard mountain route continuing above Broken Heart.',
        'ru': 'Сложный горный маршрут выше «Разбитого сердца».',
        'ky': '«Сынган жүрөктөн» жогору кеткен татаал тоо жолу.',
      },
      difficulty: AlaArchaRouteDifficulty.hard,
      distanceKm: 10.6,
      destinationId: 'komsomolets',
      path: [
        LatLng(42.5623368, 74.4824238),
        LatLng(42.5600949, 74.4841966),
        LatLng(42.5573085, 74.4870223),
        LatLng(42.5558306, 74.4926035),
        LatLng(42.5559975, 74.4926586),
        LatLng(42.5562855, 74.4955819),
        LatLng(42.5568442, 74.4974890),
        LatLng(42.5557239, 74.5023599),
        LatLng(42.5524132, 74.5077139),
        LatLng(42.5559082, 74.5108683),
        LatLng(42.5607505, 74.5114231),
        LatLng(42.5656517, 74.5255289),
        LatLng(42.5671921, 74.5370194),
        LatLng(42.5699063, 74.5474168),
      ],
    ),
    AlaArchaMapRoute(
      id: 't4',
      name: {
        'en': 'Upper Ak-Sai Glacier Approach',
        'ru': 'Верхний подход к леднику Ак-Сай',
        'ky': 'Ак-Сай мөңгүсүнө жогорку жол',
      },
      description: {
        'en': 'Advanced continuation beyond Ratsek Hut.',
        'ru': 'Продвинутое продолжение выше хижины Рацека.',
        'ky': 'Рацека үйүнөн жогору уланган татаал жол.',
      },
      difficulty: AlaArchaRouteDifficulty.hard,
      distanceKm: 12.5,
      destinationId: 'ratsek-hut',
      path: [
        LatLng(42.5623368, 74.4824238),
        LatLng(42.5558306, 74.4926035),
        LatLng(42.5524132, 74.5077139),
        LatLng(42.5473609, 74.5155618),
        LatLng(42.5362052, 74.5258031),
        LatLng(42.5349125, 74.5286827),
        LatLng(42.5331348, 74.5312245),
        LatLng(42.5315226, 74.5316488),
        LatLng(42.5256218, 74.5361812),
        LatLng(42.5219179, 74.5374581),
      ],
    ),
    AlaArchaMapRoute(
      id: 't5',
      name: {
        'en': 'Alplager Nature Walk',
        'ru': 'Прогулка вокруг альплагеря',
        'ky': 'Альплагер айланасында сейилдөө',
      },
      description: {
        'en': 'Gentle walk near the hotel and trailhead area.',
        'ru': 'Лёгкая прогулка рядом с гостиницей и стартом троп.',
        'ky': 'Мейманкана жана жол башталган жерде жеңил сейилдөө.',
      },
      difficulty: AlaArchaRouteDifficulty.easy,
      distanceKm: 1.6,
      destinationId: 'alplager',
      path: [
        LatLng(42.5623368, 74.4824238),
        LatLng(42.5619082, 74.4835661),
        LatLng(42.5615718, 74.4831581),
        LatLng(42.5600949, 74.4831520),
        LatLng(42.5593404, 74.4840175),
        LatLng(42.5598311, 74.4830595),
        LatLng(42.5615990, 74.4837245),
        LatLng(42.5623368, 74.4824238),
      ],
    ),
  ];

  static AlaArchaMapFeature? getFeatureById(String id) {
    for (final feature in features) {
      if (feature.id == id) return feature;
    }
    return null;
  }

  static AlaArchaMapRoute? getRouteById(String id) {
    for (final route in routes) {
      if (route.id == id) return route;
    }
    return null;
  }

  static String getLocalizedText(LocalizedText text, String language) {
    return text[language] ?? text['ru'] ?? text['en'] ?? text.values.first;
  }
}
