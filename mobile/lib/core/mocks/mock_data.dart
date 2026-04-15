import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_config.dart';
import '../models/accommodation_model.dart';
import '../models/pass_model.dart';
import '../models/trail_model.dart';
import '../models/tour_model.dart';
import '../models/user_model.dart';

/// Mock data for dev mode — lets the UI render without a Firebase connection.
abstract final class MockData {
  // Sources checked on 2026-04-15:
  // - Official park overview: https://alaarchapark.kg/
  // - Official price list: https://alaarchapark.kg/priceservice/
  // - Official A-Frame media: https://alaarchapark.com/
  // - Ala-Archa photos: Wikimedia Commons file pages for Ala-Archa National Park
  static const devUserId = 'dev-user';
  static const _parkScenery =
      'https://alaarchapark.kg/wp-content/uploads/2022/08/1-1024x682.jpeg';
  static const _parkEntrance =
      'https://commons.wikimedia.org/wiki/Special:FilePath/Entrance%20of%20Ala%20Archa%20National%20Park.jpg';
  static const _parkPanorama =
      'https://www.marshruty.ru/Img.ashx?T=A&D=70f59503fb6c40b7ba17dd989cb8dbf8&F=IMG_4341.JPG&S=O&R=-588041821';
  static const _parkValley =
      'https://commons.wikimedia.org/wiki/Special:FilePath/Ala%20Archa%20valley.jpg';
  static const _parkMountains =
      'https://commons.wikimedia.org/wiki/Special:FilePath/Mountains%20in%20the%20National%20Park%20Ala%20Archa%2004.jpg';
  static const _aFrameHero =
      'https://modulhouse.kg/wp-content/uploads/2019/10/01JCCVJ44WNPD9FR54G1QEZQ74.webp';
  static const _akBataHero =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTWzPNRPqHEvVSDSDp8s-hehXCYp6PKYRNPg&s';
  static const _aFrameExterior =
      'https://alaarchapark.com/_next/static/media/03-exterior.ba144427.jpg';
  static const _aFrameInterior =
      'https://alaarchapark.com/_next/static/media/05-interior.581b48b1.jpg';

  static final AppUser devUser = AppUser(
    uid: devUserId,
    email: 'dev@ala-archa.kg',
    displayName: null,
    createdAt: DateTime(2026),
  );

  static final List<ParkPass> passes = [
    ParkPass(
      id: 'p1',
      userId: devUserId,
      type: PassType.day,
      category: PassCategory.citizen,
      validFrom: DateTime(2026, 4, 5),
      validTo: DateTime(2026, 4, 6),
      qrCode: 'ALAARCHA-DEV-P1',
      price: 100,
    ),
    ParkPass(
      id: 'p2',
      userId: devUserId,
      type: PassType.multiDay,
      category: PassCategory.tourist,
      validFrom: DateTime(2026, 3, 30),
      validTo: DateTime(2026, 4, 2),
      qrCode: 'ALAARCHA-DEV-P2',
      status: PassStatus.used,
      price: 1200,
    ),
  ];

  static final accommodations = <Accommodation>[
    Accommodation(
      id: 'aframe-cottage',
      name: 'Коттедж A-Frame',
      type: AccommodationType.aFrame,
      description: const {
        'en':
            'Official A-Frame cottage for 4 guests. The park price list shows 8,850 KGS per night; meals are self-catered.',
        'ru':
            'Официальный коттедж на 4 гостей. В прейскуранте парка указана цена 8 850 сом за сутки; питание гости привозят с собой.',
        'ky':
            '4 конокко ылайыкталган расмий A-Frame коттеджи. Парк прейскурантында баасы суткасына 8 850 сом, тамакты коноктор өздөрү алып келишет.',
      },
      images: const [_aFrameHero, _aFrameExterior, _aFrameInterior],
      capacity: 4,
      pricePerNight: 8850,
      currency: 'KGS',
      amenities: const ['fireplace', 'kitchenette', 'mountain_view'],
      bookingPhone: AppConfig.aframeCottagesPhone,
    ),
    Accommodation(
      id: 'hotel-ala-archa',
      name: 'Гостиница «Ала-Арча»',
      type: AccommodationType.hotelRoom,
      description: const {
        'en':
            'Standard double room in the park’s main hotel. The official price list also mentions junior suites, a suite, and a four-bed room; breakfast is included.',
        'ru':
            'Стандартный двухместный номер в главной гостинице парка. В официальном прейскуранте также указаны полулюксы, люкс и четырехместный номер; завтрак включён.',
        'ky':
            'Парктын башкы мейманканасындагы стандарттык эки кишилик номер. Расмий прейскурантта жарым люкс, люкс жана төрт кишилик номер да көрсөтүлгөн; эртең мененки тамак кошулат.',
      },
      images: const [_parkPanorama, _parkScenery],
      capacity: 2,
      pricePerNight: 4000,
      currency: 'KGS',
      amenities: const ['breakfast', 'mountain_view', 'parking'],
      bookingPhone: AppConfig.hotelAlaArchaPhone,
    ),
    Accommodation(
      id: 'hotel-ak-maral',
      name: 'Гостиница «Ак-Марал»',
      type: AccommodationType.hotelRoom,
      description: const {
        'en':
            'Small park hotel with three room options in the official price list, including double rooms and one variant that can host up to 4 guests.',
        'ru':
            'Небольшая гостиница на территории парка. В официальном прейскуранте указаны три варианта номеров, включая двухместные и номер с малым залом на 4 гостей.',
        'ky':
            'Парктын аймагындагы чакан мейманкана. Расмий прейскурантта үч номер көрсөтүлгөн: эки кишилик жана 4 конокко ылайык вариант да бар.',
      },
      images: const [_parkValley, _parkEntrance],
      capacity: 2,
      pricePerNight: 4000,
      currency: 'KGS',
      amenities: const ['mountain_view', 'parking'],
      bookingPhone: AppConfig.hotelAkmaralPhone,
    ),
    Accommodation(
      id: 'hotel-ak-bata',
      name: 'Гостиница «Ак-Бата»',
      type: AccommodationType.hotelRoom,
      description: const {
        'en':
            'Double luxury room with breakfast. The official park price list also lists junior suites for 7,000 KGS per night.',
        'ru':
            'Двухместный номер люкс с завтраком. В официальном прейскуранте парка у этого объекта также указаны полулюксы по 7 000 сом за сутки.',
        'ky':
            'Эртең мененки тамагы кошулган эки кишилик люкс номер. Парктын расмий прейскурантында бул объект үчүн суткасына 7 000 сомдук жарым люкс да көрсөтүлгөн.',
      },
      images: const [_akBataHero, _parkMountains, _parkEntrance],
      capacity: 2,
      pricePerNight: 5000,
      currency: 'KGS',
      amenities: const ['breakfast', 'mountain_view', 'parking'],
      bookingPhone: AppConfig.hotelAkBataPhone,
    ),
  ];

  static final trails = <Trail>[
    Trail(
      id: 't1',
      name: const {
        'en': 'Ala-Archa Viewpoint Trail',
        'ru': 'Тропа к смотровой Ала-Арча',
        'ky': 'Ала-Арча көрүнүш жолу',
      },
      description: const {
        'en': 'Easy scenic walk to the park\'s most beautiful viewpoint',
        'ru': 'Лёгкая прогулка к самой красивой смотровой',
        'ky': 'Парктын эң кооз жерине жеңил жүрүш',
      },
      difficulty: '1B',
      distance: 4.5,
      elevationGain: 350,
      estimatedTimeMinutes: 120,
      status: TrailStatus.open,
      coordinates: [
        GeoPoint(42.5623368, 74.4824238),
        GeoPoint(42.5611886, 74.4831520),
        GeoPoint(42.5600949, 74.4841966),
        GeoPoint(42.5573085, 74.4870223),
        GeoPoint(42.5558306, 74.4926035),
      ],
    ),
    Trail(
      id: 't2',
      name: const {
        'en': 'Ak-Sai Waterfall Trail',
        'ru': 'Тропа к водопаду Ак-Сай',
        'ky': 'Ак-Сай шаркыратма жолу',
      },
      description: const {
        'en': 'Moderate hike to the Ak-Sai glacier waterfall',
        'ru': 'Умеренный поход к водопаду ледника Ак-Сай',
        'ky': 'Ак-Сай мөңгү шаркыратмасына орточо жүрүш',
      },
      difficulty: '2A',
      distance: 11,
      elevationGain: 800,
      estimatedTimeMinutes: 300,
      status: TrailStatus.open,
      coordinates: [
        GeoPoint(42.5623368, 74.4824238),
        GeoPoint(42.5558306, 74.4926035),
        GeoPoint(42.5568442, 74.4974890),
        GeoPoint(42.5524132, 74.5077139),
        GeoPoint(42.5473609, 74.5155618),
        GeoPoint(42.5362052, 74.5258031),
        GeoPoint(42.5349125, 74.5286827),
      ],
    ),
    Trail(
      id: 't3',
      name: const {
        'en': 'Chyngyz-Ata Peak',
        'ru': 'Пик Чынгыз-Ата',
        'ky': 'Чыңгыз-Ата чоку',
      },
      description: const {
        'en': 'Challenging ascent to a popular peak',
        'ru': 'Сложное восхождение на популярный пик',
        'ky': 'Популярдуу чокуга татаал көтөрүлүш',
      },
      difficulty: '3B',
      distance: 8,
      elevationGain: 1500,
      estimatedTimeMinutes: 480,
      status: TrailStatus.open,
      coordinates: [
        GeoPoint(42.5623368, 74.4824238),
        GeoPoint(42.5558306, 74.4926035),
        GeoPoint(42.5524132, 74.5077139),
        GeoPoint(42.5559082, 74.5108683),
        GeoPoint(42.5656517, 74.5255289),
        GeoPoint(42.5671921, 74.5370194),
        GeoPoint(42.5699063, 74.5474168),
      ],
    ),
    Trail(
      id: 't4',
      name: const {
        'en': 'Ak-Sai Glacier Route',
        'ru': 'Маршрут к леднику Ак-Сай',
        'ky': 'Ак-Сай мөңгү жолу',
      },
      description: const {
        'en': 'Advanced glacier approach. Equipment required.',
        'ru': 'Продвинутый ледниковый маршрут.',
        'ky': 'Мөңгүгө жетүү. Шайман керек.',
      },
      difficulty: '4A',
      distance: 14,
      elevationGain: 2000,
      estimatedTimeMinutes: 600,
      status: TrailStatus.caution,
      coordinates: [
        GeoPoint(42.5623368, 74.4824238),
        GeoPoint(42.5558306, 74.4926035),
        GeoPoint(42.5524132, 74.5077139),
        GeoPoint(42.5473609, 74.5155618),
        GeoPoint(42.5362052, 74.5258031),
        GeoPoint(42.5349125, 74.5286827),
        GeoPoint(42.5315226, 74.5316488),
        GeoPoint(42.5219179, 74.5374581),
      ],
    ),
    Trail(
      id: 't5',
      name: const {
        'en': 'Riverside Nature Walk',
        'ru': 'Прогулка вдоль реки',
        'ky': 'Дарыя боюнча жүрүш',
      },
      description: const {
        'en': 'Gentle walk along Ak-Sai river. Family-friendly.',
        'ru': 'Спокойная прогулка вдоль реки.',
        'ky': 'Дарыя боюнча жайбаракат жүрүш.',
      },
      difficulty: '1B',
      distance: 3,
      elevationGain: 100,
      estimatedTimeMinutes: 60,
      status: TrailStatus.open,
      coordinates: [
        GeoPoint(42.5623368, 74.4824238),
        GeoPoint(42.5619082, 74.4835661),
        GeoPoint(42.5615718, 74.4831581),
        GeoPoint(42.5600949, 74.4831520),
        GeoPoint(42.5593404, 74.4840175),
        GeoPoint(42.5598311, 74.4830595),
        GeoPoint(42.5623368, 74.4824238),
      ],
    ),
  ];

  static final tours = <Tour>[
    Tour(
      id: 'tr1',
      name: const {
        'en': 'Guided Hike to Ak-Sai Waterfall',
        'ru': 'Поход к водопаду Ак-Сай с гидом',
        'ky': 'Гид менен Ак-Сай шаркыратмасына жүрүш',
      },
      description: const {
        'en': 'Full-day guided hike with lunch',
        'ru': 'Целодневный поход с обедом',
        'ky': 'Түшкү тамак менен бүт күндүк жүрүш',
      },
      type: TourType.hiking,
      difficulty: 'moderate',
      durationMinutes: 360,
      maxParticipants: 12,
      price: 35,
    ),
    Tour(
      id: 'tr2',
      name: const {
        'en': 'Horse Trek Through Valley',
        'ru': 'Конная прогулка по долине',
        'ky': 'Өрөөн аркылуу ат менен жүрүш',
      },
      description: const {
        'en': 'Explore the valley on horseback',
        'ru': 'Исследуйте долину верхом',
        'ky': 'Ат минип өрөөндү изилдеңиз',
      },
      type: TourType.horse,
      difficulty: 'easy',
      durationMinutes: 180,
      maxParticipants: 8,
      price: 50,
    ),
    Tour(
      id: 'tr3',
      name: const {
        'en': 'Sunrise Photography Tour',
        'ru': 'Фототур на рассвете',
        'ky': 'Таңкы фототур',
      },
      description: const {
        'en': 'Golden hour at the best viewpoints',
        'ru': 'Золотой час на лучших точках',
        'ky': 'Эң жакшы жерлерде алтын саат',
      },
      type: TourType.photo,
      difficulty: 'moderate',
      durationMinutes: 240,
      maxParticipants: 6,
      price: 45,
    ),
  ];
}
