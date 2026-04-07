import '../models/service_model.dart';

/// Images from alaarchapark.com
abstract final class _Img {
  static const mountains = 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800';
  static const peaks = 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800';
  static const forest = 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800';
  static const hotel = 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800';
  static const cabin = 'https://images.unsplash.com/photo-1501556424050-d4816356e4f7?w=800';
  static const parkScenery = 'https://alaarchapark.kg/wp-content/uploads/2022/08/1-1024x682.jpeg';
}

/// Services scraped from https://alaarchapark.com/services
/// Prices are in KGS (Kyrgyz som).
abstract final class MockServices {
  static const List<Service> all = [
    // ───────────── ENTRANCE FEES ─────────────
    // NOTE: Since May 2025, gas/diesel/LPG vehicles are PROHIBITED.
    // Only electric vehicles allowed (800 KGS). Parking at entrance (2,500 spots).
    // Old per-vehicle fees below kept for reference / future re-enablement.
    Service(
      id: 's-entrance-adult',
      name: {
        'en': 'Adult Entry',
        'ru': 'Вход (взрослый)',
        'ky': 'Кирүү (чоң киши)',
      },
      description: {
        'en': 'Per person entry fee (adults)',
        'ru': 'Входной билет с человека (взрослый)',
        'ky': 'Бир чоң кишиге кирүү акысы',
      },
      category: ServiceCategory.entrance,
      priceKgs: 200,
      unit: PriceUnit.perPerson,
      images: [_Img.mountains, _Img.parkScenery],
    ),
    Service(
      id: 's-entrance-child',
      name: {
        'en': 'Child Entry (7–14)',
        'ru': 'Вход (ребёнок 7–14)',
        'ky': 'Кирүү (бала 7–14)',
      },
      description: {
        'en': 'Per child (7–14 years)',
        'ru': 'Входной билет для детей 7–14 лет',
        'ky': '7–14 жаштагы балдар үчүн',
      },
      category: ServiceCategory.entrance,
      priceKgs: 150,
      unit: PriceUnit.perPerson,
      images: [_Img.mountains],
    ),
    Service(
      id: 's-entrance-electric-vehicle',
      name: {
        'en': 'Electric Vehicle Entry',
        'ru': 'Въезд электромобиля',
        'ky': 'Электромобиль кирүү',
      },
      description: {
        'en': 'Entry for electric vehicles only (gas/diesel prohibited)',
        'ru': 'Въезд для электромобилей (бензин/дизель запрещён)',
        'ky': 'Электромобилдер үчүн гана (бензин/дизель тыюу)',
      },
      category: ServiceCategory.entrance,
      priceKgs: 800,
      unit: PriceUnit.perVehicle,
      images: [_Img.mountains],
    ),
    Service(
      id: 's-entrance-gondola',
      name: {
        'en': 'Gondola (round trip)',
        'ru': 'Канатная дорога (туда-обратно)',
        'ky': 'Канат жол (бара-кайтара)',
      },
      description: {
        'en':
            'Doppelmayr gondola, 1 km, 2166→2494 m. 16 cabins (10-seat + 2 VIP 4-seat). Cashless only.',
        'ru':
            'Гондола Doppelmayr, 1 км, 2166→2494 м. 16 кабин (10 мест + 2 VIP на 4). Только безнал.',
        'ky':
            'Doppelmayr гондоласы, 1 км, 2166→2494 м. 16 кабина (10 орун + 2 VIP 4 орун). Накталай эмес гана.',
      },
      category: ServiceCategory.entrance,
      priceKgs: 600,
      unit: PriceUnit.perPerson,
      images: [_Img.peaks, _Img.mountains],
    ),
    Service(
      id: 's-entrance-gondola-child',
      name: {
        'en': 'Gondola — Child (round trip)',
        'ru': 'Канатная дорога — ребёнок',
        'ky': 'Канат жол — бала',
      },
      description: {
        'en': 'Round trip gondola ticket for children',
        'ru': 'Проезд на канатной дороге для детей (туда-обратно)',
        'ky': 'Балдар үчүн канат жолго билет (бара-кайтара)',
      },
      category: ServiceCategory.entrance,
      priceKgs: 400,
      unit: PriceUnit.perPerson,
      images: [_Img.peaks],
    ),

    // ───────────── KHAN-TENIRI ─────────────
    Service(
      id: 's-kt-barnhouse',
      venue: 'Khan-Teniri',
      name: {
        'en': 'Khan-Teniri Barnhouse',
        'ru': 'Барнхаус Khan-Teniri',
        'ky': 'Khan-Teniri барнхаусу',
      },
      description: {
        'en':
            'Modern barnhouse with sauna & jacuzzi. Free gondola for guests. \$250/night.',
        'ru':
            'Современный барнхаус с сауной и джакузи. Бесплатная канатка для гостей. \$250/ночь.',
        'ky':
            'Заманбап барнхаус, сауна жана джакузи. Конокторго канат жол акысыз. \$250/түнгө.',
      },
      category: ServiceCategory.hotel,
      priceKgs: 21500, // ~$250 at ~86 KGS/USD
      unit: PriceUnit.perNight,
      images: [_Img.hotel, _Img.cabin, _Img.mountains],
      capacity: 4,
    ),

    // ───────────── HOTELS ─────────────
    Service(
      id: 's-hotel-ala-archa-7',
      venue: 'Ala-Archa Hotel',
      name: {
        'en': 'Suite #7',
        'ru': 'Люкс №7',
        'ky': 'Люкс №7',
      },
      description: {
        'en': 'Double room, breakfast included',
        'ru': 'Двухместный, завтрак включён',
        'ky': 'Эки кишилик, эртең мененки тамак менен',
      },
      category: ServiceCategory.hotel,
      priceKgs: 9000,
      unit: PriceUnit.perNight,
      images: [_Img.hotel],
      capacity: 2,
    ),
    Service(
      id: 's-hotel-ala-archa-5-6',
      venue: 'Ala-Archa Hotel',
      name: {
        'en': 'Junior Suite #5–6',
        'ru': 'Полулюкс №5–6',
        'ky': 'Жарым люкс №5–6',
      },
      description: {
        'en': 'Double room, breakfast included',
        'ru': 'Двухместный, завтрак включён',
        'ky': 'Эки кишилик, эртең мененки тамак менен',
      },
      category: ServiceCategory.hotel,
      priceKgs: 6000,
      unit: PriceUnit.perNight,
      images: [_Img.hotel],
      capacity: 2,
    ),
    Service(
      id: 's-hotel-ala-archa-8',
      venue: 'Ala-Archa Hotel',
      name: {
        'en': 'Room #8',
        'ru': 'Номер №8',
        'ky': 'Номер №8',
      },
      description: {
        'en': 'Quad room, breakfast included',
        'ru': 'Четырёхместный, завтрак включён',
        'ky': 'Төрт кишилик, эртең мененки тамак менен',
      },
      category: ServiceCategory.hotel,
      priceKgs: 7000,
      unit: PriceUnit.perNight,
      images: [_Img.hotel],
      capacity: 4,
    ),
    Service(
      id: 's-hotel-ala-archa-1-4',
      venue: 'Ala-Archa Hotel',
      name: {
        'en': 'Rooms #1–4',
        'ru': 'Номера №1–4',
        'ky': 'Номерлер №1–4',
      },
      description: {
        'en': 'Double room, breakfast included',
        'ru': 'Двухместный, завтрак включён',
        'ky': 'Эки кишилик, эртең мененки тамак менен',
      },
      category: ServiceCategory.hotel,
      priceKgs: 4000,
      unit: PriceUnit.perNight,
      images: [_Img.hotel],
      capacity: 2,
    ),
    Service(
      id: 's-hotel-ala-archa-mattress',
      venue: 'Ala-Archa Hotel',
      name: {
        'en': 'Extra Mattress with Bedding',
        'ru': 'Доп. матрас с бельём',
        'ky': 'Кошумча матрас менен төшөк',
      },
      description: {
        'en': 'Additional mattress in shared room',
        'ru': 'Дополнительный матрас в номере',
        'ky': 'Номерге кошумча матрас',
      },
      category: ServiceCategory.hotel,
      priceKgs: 500,
      unit: PriceUnit.perNight,
      images: [_Img.hotel],
      phone: '+996 701 551 026',
    ),
    Service(
      id: 's-hotel-akmaral',
      venue: 'Ak-Maral Hotel',
      name: {
        'en': 'Rooms #1–3',
        'ru': 'Номера №1–3',
        'ky': 'Номерлер №1–3',
      },
      description: {
        'en': 'Double rooms (Room #2 has large hall, Room #3 has small hall for 4)',
        'ru': 'Двухместные (№2 с большим залом, №3 с малым залом на 4)',
        'ky': 'Эки кишилик (№2 чоң зал, №3 4 кишиге кичи зал)',
      },
      category: ServiceCategory.hotel,
      priceKgs: 4000,
      unit: PriceUnit.perNight,
      images: [_Img.hotel],
      capacity: 2,
    ),
    Service(
      id: 's-hotel-akbata-junior',
      venue: 'Ak-Bata Hotel',
      name: {
        'en': 'Junior Suite #3–6',
        'ru': 'Полулюкс №3–6',
        'ky': 'Жарым люкс №3–6',
      },
      description: {
        'en': 'Double room, breakfast included',
        'ru': 'Двухместный, завтрак включён',
        'ky': 'Эки кишилик, эртең мененки тамак менен',
      },
      category: ServiceCategory.hotel,
      priceKgs: 7000,
      unit: PriceUnit.perNight,
      images: [_Img.hotel],
      capacity: 2,
    ),
    Service(
      id: 's-hotel-akbata-suite',
      venue: 'Ak-Bata Hotel',
      name: {
        'en': 'Suite #1, #2, #7, #8',
        'ru': 'Люкс №1, 2, 7, 8',
        'ky': 'Люкс №1, 2, 7, 8',
      },
      description: {
        'en': 'Double room, breakfast included',
        'ru': 'Двухместный, завтрак включён',
        'ky': 'Эки кишилик, эртең мененки тамак менен',
      },
      category: ServiceCategory.hotel,
      priceKgs: 5000,
      unit: PriceUnit.perNight,
      images: [_Img.hotel],
      capacity: 2,
    ),

    // ───────────── VENUE HALLS ─────────────
    Service(
      id: 's-hall-conf-30',
      name: {
        'en': 'Conference Hall (30 seats)',
        'ru': 'Конференц-зал (30 мест)',
        'ky': 'Конференц-зал (30 орун)',
      },
      description: {
        'en': 'First hour 2,000 KGS; each additional 1,000 KGS',
        'ru': 'Первый час 2 000; далее 1 000 сом/час',
        'ky': 'Биринчи саат 2 000; кийинкиси 1 000 сом',
      },
      category: ServiceCategory.venue,
      priceKgs: 2000,
      unit: PriceUnit.perHour,
      images: [_Img.hotel],
      capacity: 30,
    ),
    Service(
      id: 's-hall-banquet-10',
      name: {
        'en': 'Banquet Hall (10 seats)',
        'ru': 'Банкетный зал (10 мест)',
        'ky': 'Банкет залы (10 орун)',
      },
      description: {
        'en': 'First hour 500 KGS; each additional 250 KGS',
        'ru': 'Первый час 500; далее 250 сом/час',
        'ky': 'Биринчи саат 500; кийинкиси 250 сом',
      },
      category: ServiceCategory.venue,
      priceKgs: 500,
      unit: PriceUnit.perHour,
      images: [_Img.hotel],
      capacity: 10,
    ),
    Service(
      id: 's-hall-banquet-30',
      name: {
        'en': 'Banquet Hall (30 seats)',
        'ru': 'Банкетный зал (30 мест)',
        'ky': 'Банкет залы (30 орун)',
      },
      description: {
        'en': 'First hour 2,000 KGS; each additional 500 KGS',
        'ru': 'Первый час 2 000; далее 500 сом/час',
        'ky': 'Биринчи саат 2 000; кийинкиси 500 сом',
      },
      category: ServiceCategory.venue,
      priceKgs: 2000,
      unit: PriceUnit.perHour,
      images: [_Img.hotel],
      capacity: 30,
    ),
    Service(
      id: 's-hall-fireplace',
      name: {
        'en': 'Fireplace Hall (10 seats)',
        'ru': 'Каминный зал (10 мест)',
        'ky': 'Камин залы (10 орун)',
      },
      description: {
        'en': 'First hour 1,000 KGS; each additional 500 KGS',
        'ru': 'Первый час 1 000; далее 500 сом/час',
        'ky': 'Биринчи саат 1 000; кийинкиси 500 сом',
      },
      category: ServiceCategory.venue,
      priceKgs: 1000,
      unit: PriceUnit.perHour,
      images: [_Img.hotel],
      capacity: 10,
    ),
    Service(
      id: 's-hall-yurt-national',
      name: {
        'en': 'National Yurt (15 seats)',
        'ru': 'Национальная юрта (15 мест)',
        'ky': 'Улуттук боз үй (15 орун)',
      },
      description: {
        'en': 'First hour 1,000 KGS; each additional 500 KGS',
        'ru': 'Первый час 1 000; далее 500 сом/час',
        'ky': 'Биринчи саат 1 000; кийинкиси 500 сом',
      },
      category: ServiceCategory.venue,
      priceKgs: 1000,
      unit: PriceUnit.perHour,
      images: [_Img.forest, _Img.mountains],
      capacity: 15,
    ),
    Service(
      id: 's-hall-akbata-45',
      venue: 'Ak-Bata',
      name: {
        'en': 'Conference Hall (45 seats)',
        'ru': 'Конференц-зал (45 мест)',
        'ky': 'Конференц-зал (45 орун)',
      },
      description: {
        'en': 'Flat hourly rate',
        'ru': 'Фиксированная ставка за час',
        'ky': 'Бекитилген сааттык тариф',
      },
      category: ServiceCategory.venue,
      priceKgs: 4000,
      unit: PriceUnit.perHour,
      images: [_Img.hotel],
      capacity: 45,
    ),
    Service(
      id: 's-hall-akbata-70',
      venue: 'Ak-Bata',
      name: {
        'en': 'Conference Hall (70 seats)',
        'ru': 'Конференц-зал (70 мест)',
        'ky': 'Конференц-зал (70 орун)',
      },
      description: {
        'en': 'Flat hourly rate',
        'ru': 'Фиксированная ставка за час',
        'ky': 'Бекитилген сааттык тариф',
      },
      category: ServiceCategory.venue,
      priceKgs: 5000,
      unit: PriceUnit.perHour,
      images: [_Img.hotel],
      capacity: 70,
    ),

    // ───────────── RECREATION ─────────────
    Service(
      id: 's-rec-aframe',
      name: {
        'en': 'A-Frame Cottage',
        'ru': 'А-коттедж',
        'ky': 'А-коттедж',
      },
      description: {
        'en': '4 guests, guests bring their own meals',
        'ru': '4 гостя, еду гости приносят сами',
        'ky': '4 коноктун тамагын өздөрү алып келет',
      },
      category: ServiceCategory.recreation,
      priceKgs: 8850,
      unit: PriceUnit.perNight,
      images: [_Img.cabin, _Img.forest],
      capacity: 4,
    ),
    Service(
      id: 's-rec-forest-house',
      name: {
        'en': 'House in the Forest',
        'ru': '«Дом в лесу»',
        'ky': '«Токойдогу үй»',
      },
      description: {
        'en': '16-person hall, bedroom, kitchen',
        'ru': 'Зал на 16 мест, спальня, кухня',
        'ky': '16 орундуу зал, уктоочу бөлмө, ашкана',
      },
      category: ServiceCategory.recreation,
      priceKgs: 2500,
      unit: PriceUnit.perNight,
      images: [_Img.forest, _Img.cabin],
      capacity: 16,
    ),
    Service(
      id: 's-rec-simple-yurt',
      name: {
        'en': 'Simple Yurt',
        'ru': 'Простая юрта',
        'ky': 'Жөнөкөй боз үй',
      },
      description: {
        'en': 'Traditional yurt for rent',
        'ru': 'Традиционная юрта в аренду',
        'ky': 'Салттуу боз үй ижарага',
      },
      category: ServiceCategory.recreation,
      priceKgs: 1000,
      unit: PriceUnit.perNight,
      images: [_Img.forest, _Img.mountains],
    ),
    Service(
      id: 's-rec-summer-cottage',
      name: {
        'en': 'Summer Cottages',
        'ru': 'Летние коттеджи',
        'ky': 'Жайкы коттедждер',
      },
      description: {
        'en': 'Per-room rate',
        'ru': 'За каждый номер',
        'ky': 'Ар бир номер үчүн',
      },
      category: ServiceCategory.recreation,
      priceKgs: 6000,
      unit: PriceUnit.perNight,
      images: [_Img.cabin, _Img.forest],
    ),
    Service(
      id: 's-rec-canopy',
      name: {
        'en': 'Summer Canopy',
        'ru': 'Летний навес',
        'ky': 'Жайкы навес',
      },
      description: {
        'en': '6 hours, table service for 10',
        'ru': '6 часов, стол на 10 человек',
        'ky': '6 саат, 10 кишиге үстөл',
      },
      category: ServiceCategory.recreation,
      priceKgs: 400,
      unit: PriceUnit.perTable,
      images: [_Img.forest],
      capacity: 10,
    ),
    Service(
      id: 's-rec-botanik',
      name: {
        'en': 'Botanik',
        'ru': '«Ботаник»',
        'ky': '«Ботаник»',
      },
      description: {
        'en': '16-person hall, bedroom, kitchen',
        'ru': 'Зал на 16 мест, спальня, кухня',
        'ky': '16 орундуу зал, уктоочу бөлмө, ашкана',
      },
      category: ServiceCategory.recreation,
      priceKgs: 2000,
      unit: PriceUnit.perNight,
      images: [_Img.forest],
      capacity: 16,
    ),
    Service(
      id: 's-rec-cafebar',
      name: {
        'en': 'Cafe-Bars Adygene & Boyrok',
        'ru': 'Кафе-бары «Адыгене» и «Бойрок»',
        'ky': '«Адыгене» жана «Бойрок» кафе-барлары',
      },
      description: {
        'en': 'Per table, per day',
        'ru': 'За стол, в день',
        'ky': 'Бир үстөлгө, күнүнө',
      },
      category: ServiceCategory.recreation,
      priceKgs: 400,
      unit: PriceUnit.perTable,
      images: [_Img.forest, _Img.mountains],
    ),
    Service(
      id: 's-rec-alplager',
      name: {
        'en': 'Alplager Canteen',
        'ru': 'Столовая «Альплагерь»',
        'ky': '«Альплагерь» ашканасы',
      },
      description: {
        'en': 'Per table, per day',
        'ru': 'За стол, в день',
        'ky': 'Бир үстөлгө, күнүнө',
      },
      category: ServiceCategory.recreation,
      priceKgs: 400,
      unit: PriceUnit.perTable,
      images: [_Img.mountains, _Img.peaks],
    ),
    Service(
      id: 's-rec-salkyn-tor',
      name: {
        'en': 'Gazebo Salkyn-Tor (50 seats)',
        'ru': 'Беседка «Салкын-Тор» (50 мест)',
        'ky': '«Салкын-Тор» беседкасы (50 орун)',
      },
      description: {
        'en': '1,500 KGS/table; +1,000 KGS each additional hour; 6,000 KGS for 5+ hours',
        'ru': '1 500 сом/стол; +1 000 сом/час; 6 000 сом за 5+ часов',
        'ky': '1 500 сом/үстөл; +1 000 сом/саат; 6 000 сом 5+ саатка',
      },
      category: ServiceCategory.recreation,
      priceKgs: 1500,
      unit: PriceUnit.perTable,
      images: [_Img.forest],
      capacity: 50,
    ),

    // ───────────── RENTALS / ACTIVITIES ─────────────
    Service(
      id: 's-rent-sauna',
      name: {
        'en': 'Sauna',
        'ru': 'Сауна',
        'ky': 'Сауна',
      },
      description: {
        'en': 'Per person, per hour',
        'ru': 'С человека в час',
        'ky': 'Бир кишиге, сааттык',
      },
      category: ServiceCategory.rental,
      priceKgs: 200,
      unit: PriceUnit.perHour,
      images: [_Img.hotel],
    ),
    Service(
      id: 's-rent-horse',
      name: {
        'en': 'Horse Riding',
        'ru': 'Конные прогулки',
        'ky': 'Ат минүү',
      },
      description: {
        'en': 'Per horse, per hour',
        'ru': 'За лошадь в час',
        'ky': 'Бир атка, сааттык',
      },
      category: ServiceCategory.rental,
      priceKgs: 400,
      unit: PriceUnit.perHour,
      images: [_Img.mountains, _Img.forest],
    ),
    Service(
      id: 's-rent-skating',
      name: {
        'en': 'Ice Skating',
        'ru': 'Катание на коньках',
        'ky': 'Коньки тебүү',
      },
      description: {
        'en': 'Per person, per hour',
        'ru': 'С человека в час',
        'ky': 'Бир кишиге, сааттык',
      },
      category: ServiceCategory.rental,
      priceKgs: 100,
      unit: PriceUnit.perHour,
      images: [_Img.mountains],
    ),
    Service(
      id: 's-rent-guide',
      name: {
        'en': 'Guide Services',
        'ru': 'Услуги гида',
        'ky': 'Гид кызматы',
      },
      description: {
        'en': 'Per hour',
        'ru': 'За час',
        'ky': 'Бир саатка',
      },
      category: ServiceCategory.rental,
      priceKgs: 300,
      unit: PriceUnit.perHour,
      images: [_Img.peaks, _Img.mountains],
    ),
    Service(
      id: 's-rent-tapchan',
      name: {
        'en': 'Tapchan',
        'ru': 'Аренда тапчана',
        'ky': 'Тапчан ижарасы',
      },
      description: {
        'en': 'Per hour',
        'ru': 'За час',
        'ky': 'Бир саатка',
      },
      category: ServiceCategory.rental,
      priceKgs: 200,
      unit: PriceUnit.perHour,
      images: [_Img.forest],
    ),

    // ───────────── EXTRA ─────────────
    Service(
      id: 's-extra-museum-adult',
      name: {
        'en': 'Museum Visit (adult)',
        'ru': 'Посещение музея (взрослый)',
        'ky': 'Музейге баруу (чоң киши)',
      },
      description: {
        'en': 'Per person',
        'ru': 'С человека',
        'ky': 'Бир кишиге',
      },
      category: ServiceCategory.extra,
      priceKgs: 50,
      unit: PriceUnit.perPerson,
      images: [_Img.parkScenery],
    ),
    Service(
      id: 's-extra-museum-child',
      name: {
        'en': 'Museum Visit (child under 12)',
        'ru': 'Посещение музея (до 12)',
        'ky': 'Музейге баруу (12 жашка чейин)',
      },
      description: {
        'en': 'Per child',
        'ru': 'За ребёнка',
        'ky': 'Бир балага',
      },
      category: ServiceCategory.extra,
      priceKgs: 20,
      unit: PriceUnit.perPerson,
      images: [_Img.parkScenery],
    ),
    Service(
      id: 's-extra-dishes',
      name: {
        'en': 'Dishes & Cutlery',
        'ru': 'Посуда и приборы',
        'ky': 'Идиш-аяк',
      },
      description: {
        'en': '4 hours, set for 10',
        'ru': '4 часа, набор на 10 человек',
        'ky': '4 саатка, 10 кишиге',
      },
      category: ServiceCategory.extra,
      priceKgs: 250,
      unit: PriceUnit.flat,
      images: [_Img.forest],
    ),
    Service(
      id: 's-extra-cauldron',
      name: {
        'en': 'Cauldron',
        'ru': 'Казан',
        'ky': 'Казан',
      },
      description: {
        'en': '4 hours',
        'ru': '4 часа',
        'ky': '4 саатка',
      },
      category: ServiceCategory.extra,
      priceKgs: 250,
      unit: PriceUnit.flat,
      images: [_Img.forest],
    ),
    Service(
      id: 's-extra-grill',
      name: {
        'en': 'Grill',
        'ru': 'Мангал',
        'ky': 'Мангал',
      },
      description: {
        'en': '4 hours',
        'ru': '4 часа',
        'ky': '4 саатка',
      },
      category: ServiceCategory.extra,
      priceKgs: 200,
      unit: PriceUnit.flat,
      images: [_Img.forest],
    ),
    Service(
      id: 's-extra-kitchen',
      name: {
        'en': 'Kitchen Access',
        'ru': 'Аренда кухни',
        'ky': 'Ашкана ижарасы',
      },
      description: {
        'en': '4 hours of cooking access',
        'ru': '4 часа, готовка',
        'ky': '4 саат, тамак жасоо',
      },
      category: ServiceCategory.extra,
      priceKgs: 2000,
      unit: PriceUnit.flat,
      images: [_Img.hotel],
    ),
    Service(
      id: 's-extra-cooking',
      name: {
        'en': 'Cooking from Your Ingredients',
        'ru': 'Готовка из продуктов гостя',
        'ky': 'Коноктун азыктарынан тамак жасоо',
      },
      description: {
        'en': 'Per portion',
        'ru': 'За порцию',
        'ky': 'Бир порцияга',
      },
      category: ServiceCategory.extra,
      priceKgs: 50,
      unit: PriceUnit.perItem,
      images: [_Img.forest],
    ),
    Service(
      id: 's-extra-hearth',
      name: {
        'en': 'Hearth with Cauldron',
        'ru': 'Очаг с казаном',
        'ky': 'Казан менен очок',
      },
      description: {
        'en': 'Per hour',
        'ru': 'За час',
        'ky': 'Бир саатка',
      },
      category: ServiceCategory.extra,
      priceKgs: 100,
      unit: PriceUnit.perHour,
      images: [_Img.forest],
    ),
    Service(
      id: 's-extra-storage',
      name: {
        'en': 'Luggage Storage',
        'ru': 'Камера хранения',
        'ky': 'Жүк сактоочу',
      },
      description: {
        'en': 'Up to 20 kg, per day',
        'ru': 'До 20 кг, в день',
        'ky': '20 кгга чейин, күнүнө',
      },
      category: ServiceCategory.extra,
      priceKgs: 200,
      unit: PriceUnit.perDay,
      images: [_Img.hotel],
    ),
    Service(
      id: 's-extra-tent',
      name: {
        'en': 'Tent Setup',
        'ru': 'Установка палатки',
        'ky': 'Чатыр коюу',
      },
      description: {
        'en': 'Per day',
        'ru': 'В день',
        'ky': 'Күнүнө',
      },
      category: ServiceCategory.extra,
      priceKgs: 200,
      unit: PriceUnit.perDay,
      images: [_Img.mountains, _Img.forest],
    ),
    Service(
      id: 's-extra-yurt-setup',
      name: {
        'en': 'Yurt Setup',
        'ru': 'Установка юрты',
        'ky': 'Боз үй тигүү',
      },
      description: {
        'en': 'Per day',
        'ru': 'В день',
        'ky': 'Күнүнө',
      },
      category: ServiceCategory.extra,
      priceKgs: 200,
      unit: PriceUnit.perDay,
      images: [_Img.forest, _Img.mountains],
    ),
    Service(
      id: 's-extra-blankets',
      name: {
        'en': 'Blankets',
        'ru': 'Одеяла',
        'ky': 'Жууркан',
      },
      description: {
        'en': '4 hours, 2 pieces',
        'ru': '4 часа, 2 штуки',
        'ky': '4 саат, 2 даана',
      },
      category: ServiceCategory.extra,
      priceKgs: 200,
      unit: PriceUnit.flat,
      images: [_Img.cabin],
    ),
    Service(
      id: 's-extra-shower',
      name: {
        'en': 'Shower',
        'ru': 'Душ',
        'ky': 'Душ',
      },
      description: {
        'en': 'Per person, per hour',
        'ru': 'С человека в час',
        'ky': 'Бир кишиге, сааттык',
      },
      category: ServiceCategory.extra,
      priceKgs: 100,
      unit: PriceUnit.perHour,
      images: [_Img.hotel],
    ),
    Service(
      id: 's-extra-restroom',
      name: {
        'en': 'Restroom',
        'ru': 'Туалет',
        'ky': 'Даараткана',
      },
      description: {
        'en': 'Per person',
        'ru': 'С человека',
        'ky': 'Бир кишиге',
      },
      category: ServiceCategory.extra,
      priceKgs: 10,
      unit: PriceUnit.perPerson,
      images: [_Img.mountains],
    ),
  ];
}
