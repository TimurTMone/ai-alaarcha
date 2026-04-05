import '../models/service_model.dart';

/// Services scraped from https://alaarchapark.com/services
/// Prices are in KGS (Kyrgyz som).
abstract final class MockServices {
  static const List<Service> all = [
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
      capacity: 2,
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
        'en': 'Double room',
        'ru': 'Двухместный номер',
        'ky': 'Эки кишилик номер',
      },
      category: ServiceCategory.hotel,
      priceKgs: 4000,
      unit: PriceUnit.perNight,
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
    ),
  ];
}
