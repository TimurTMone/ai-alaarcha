import '../models/accommodation_model.dart';
import '../models/pass_model.dart';
import '../models/trail_model.dart';
import '../models/tour_model.dart';
import '../models/user_model.dart';

/// Mock data for dev mode — lets the UI render without a Firebase connection.
abstract final class MockData {
  static const devUserId = 'dev-user';

  static final AppUser devUser = AppUser(
    uid: devUserId,
    email: 'dev@ala-archa.kg',
    displayName: 'Dev User',
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
      id: 'mock-1',
      name: 'Khan-Teniri Barnhouse A',
      type: AccommodationType.barnhouse,
      description: const {
        'en': 'Premium mountain barnhouse with panoramic Tien Shan views',
        'ru': 'Премиум горный барнхаус с панорамным видом на Тянь-Шань',
        'ky': 'Тянь-Шань панорамалык көрүнүшү менен премиум барнхаус',
      },
      capacity: 6,
      pricePerNight: 250,
      amenities: const ['wifi', 'heating', 'kitchen', 'mountain_view'],
      includesGondola: true,
      rating: 4.8,
      reviewCount: 24,
    ),
    Accommodation(
      id: 'mock-2',
      name: 'Alpine A-Frame Cabin',
      type: AccommodationType.aFrame,
      description: const {
        'en': 'Cozy A-frame cabin in the alpine forest',
        'ru': 'Уютный А-образный домик в горном лесу',
        'ky': 'Тоо токойундагы жайлуу А-формадагы үй',
      },
      capacity: 4,
      pricePerNight: 120,
      amenities: const ['heating', 'fireplace', 'kitchenette'],
      includesGondola: false,
      rating: 4.6,
      reviewCount: 18,
    ),
    Accommodation(
      id: 'mock-3',
      name: 'Mountain Dome',
      type: AccommodationType.dome,
      description: const {
        'en': 'Geodesic dome with transparent ceiling for stargazing',
        'ru': 'Геодезический купол с прозрачным потолком',
        'ky': 'Тунук шыптуу геодезиялык купол',
      },
      capacity: 3,
      pricePerNight: 90,
      amenities: const ['transparent_ceiling', 'heating'],
      includesGondola: false,
      rating: 4.9,
      reviewCount: 31,
    ),
    Accommodation(
      id: 'mock-4',
      name: 'ALTO Cabin',
      type: AccommodationType.cabin,
      description: const {
        'en': 'Modern mountain cabin',
        'ru': 'Современная горная кабина',
        'ky': 'Заманбап тоо кабинасы',
      },
      capacity: 4,
      pricePerNight: 150,
      amenities: const ['wifi', 'heating', 'kitchen'],
      includesGondola: false,
      rating: 4.7,
      reviewCount: 15,
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
