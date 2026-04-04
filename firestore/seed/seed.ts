import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

// Run: npx ts-node firestore/seed/seed.ts
// Requires GOOGLE_APPLICATION_CREDENTIALS env var or service account

initializeApp();
const db = getFirestore();

const accommodations = [
  {
    name: 'Khan-Teniri Barnhouse A',
    type: 'barnhouse',
    description: {
      en: 'Premium mountain barnhouse with panoramic views of the Tien Shan range',
      ru: 'Премиум горный барнхаус с панорамным видом на хребет Тянь-Шань',
      ky: 'Тянь-Шань кыркасынын панорамалык көрүнүшү менен премиум тоо барнхаусу',
    },
    capacity: 6,
    pricePerNight: 250,
    currency: 'USD',
    amenities: ['wifi', 'heating', 'kitchen', 'mountain_view', 'parking'],
    includesGondola: true,
    images: [],
    rating: 4.8,
    reviewCount: 24,
  },
  {
    name: 'Alpine A-Frame Cabin',
    type: 'a_frame',
    description: {
      en: 'Cozy A-frame cabin nestled in the alpine forest',
      ru: 'Уютный А-образный домик в горном лесу',
      ky: 'Тоо токойундагы жайлуу А-формадагы үй',
    },
    capacity: 4,
    pricePerNight: 120,
    currency: 'USD',
    amenities: ['heating', 'fireplace', 'kitchenette'],
    includesGondola: false,
    images: [],
    rating: 4.6,
    reviewCount: 18,
  },
  {
    name: 'Mountain Dome',
    type: 'dome',
    description: {
      en: 'Unique geodesic dome with transparent ceiling for stargazing',
      ru: 'Уникальный геодезический купол с прозрачным потолком для наблюдения за звёздами',
      ky: 'Жылдыздарды байкоо үчүн тунук шыптуу уникалдуу геодезиялык купол',
    },
    capacity: 3,
    pricePerNight: 90,
    currency: 'USD',
    amenities: ['transparent_ceiling', 'heating', 'bed'],
    includesGondola: false,
    images: [],
    rating: 4.9,
    reviewCount: 31,
  },
  {
    name: 'ALTO Mountain Cabin',
    type: 'cabin',
    description: {
      en: 'Modern mountain cabin with all comforts of home',
      ru: 'Современная горная кабина со всеми удобствами',
      ky: 'Бардык ыңгайлуулуктары бар заманбап тоо кабинасы',
    },
    capacity: 4,
    pricePerNight: 150,
    currency: 'USD',
    amenities: ['wifi', 'heating', 'kitchen', 'hot_shower'],
    includesGondola: false,
    images: [],
    rating: 4.7,
    reviewCount: 15,
  },
  {
    name: 'Rasek Mountain Hut',
    type: 'hut',
    description: {
      en: 'Base camp at 3,400m for mountaineers and serious trekkers',
      ru: 'Базовый лагерь на высоте 3400м для альпинистов',
      ky: 'Альпинисттер үчүн 3400м бийиктиктеги базалык лагерь',
    },
    capacity: 20,
    pricePerNight: 25,
    currency: 'USD',
    amenities: ['shared_bunks', 'basic_kitchen'],
    includesGondola: false,
    images: [],
    rating: 4.3,
    reviewCount: 42,
  },
];

const trails = [
  {
    name: { en: 'Ala-Archa Viewpoint Trail', ru: 'Тропа к смотровой площадке Ала-Арча', ky: 'Ала-Арча көрүнүш жолу' },
    description: { en: 'Easy scenic walk to the park\'s most beautiful viewpoint. Family-friendly.', ru: 'Лёгкая живописная прогулка к самой красивой смотровой площадке парка.', ky: 'Парктын эң кооз көрүнүш жерине жеңил жүрүш.' },
    difficulty: '1B', distance: 4.5, elevationGain: 350, estimatedTime: 120, status: 'open', images: [],
  },
  {
    name: { en: 'Ak-Sai Waterfall Trail', ru: 'Тропа к водопаду Ак-Сай', ky: 'Ак-Сай шаркыратма жолу' },
    description: { en: 'Moderate hike to the stunning Ak-Sai glacier waterfall.', ru: 'Умеренный поход к потрясающему водопаду ледника Ак-Сай.', ky: 'Ак-Сай мөңгү шаркыратмасына орточо жүрүш.' },
    difficulty: '2A', distance: 11, elevationGain: 800, estimatedTime: 300, status: 'open', images: [],
  },
  {
    name: { en: 'Chyngyz-Ata Peak', ru: 'Пик Чынгыз-Ата', ky: 'Чыңгыз-Ата чоку' },
    description: { en: 'Challenging ascent to one of the most popular peaks for mountaineers.', ru: 'Сложное восхождение на один из самых популярных пиков для альпинистов.', ky: 'Альпинисттер үчүн эң популярдуу чокуларга татаал көтөрүлүш.' },
    difficulty: '3B', distance: 8, elevationGain: 1500, estimatedTime: 480, status: 'open', images: [],
  },
  {
    name: { en: 'Ak-Sai Glacier Route', ru: 'Маршрут к леднику Ак-Сай', ky: 'Ак-Сай мөңгү жолу' },
    description: { en: 'Advanced glacier approach. Requires proper equipment and experience.', ru: 'Продвинутый ледниковый маршрут. Требуется снаряжение и опыт.', ky: 'Мөңгүгө жетүү. Шаймандар жана тажрыйба талап кылынат.' },
    difficulty: '4A', distance: 14, elevationGain: 2000, estimatedTime: 600, status: 'caution', images: [],
  },
  {
    name: { en: 'Riverside Nature Walk', ru: 'Прогулка вдоль реки', ky: 'Дарыя боюнча жүрүш' },
    description: { en: 'Gentle walk along Ak-Sai river. Perfect for families and relaxation.', ru: 'Спокойная прогулка вдоль реки Ак-Сай. Идеально для семей.', ky: 'Ак-Сай дарыясы боюнча жайбаракат жүрүш. Үй-бүлөлөр үчүн идеалдуу.' },
    difficulty: '1B', distance: 3, elevationGain: 100, estimatedTime: 60, status: 'open', images: [],
  },
];

const tours = [
  {
    name: { en: 'Guided Day Hike to Ak-Sai Waterfall', ru: 'Поход к водопаду Ак-Сай с гидом', ky: 'Гид менен Ак-Сай шаркыратмасына жүрүш' },
    description: { en: 'Full-day guided hike to the Ak-Sai waterfall with lunch included.', ru: 'Целодневный поход к водопаду Ак-Сай с обедом.', ky: 'Түшкү тамак менен Ак-Сай шаркыратмасына бүт күндүк жүрүш.' },
    type: 'hiking', difficulty: 'moderate', duration: 360, maxParticipants: 12, price: 35, currency: 'USD',
  },
  {
    name: { en: 'Horse Trek Through the Valley', ru: 'Конная прогулка по долине', ky: 'Өрөөн аркылуу ат менен жүрүш' },
    description: { en: 'Explore the valley on horseback with experienced guides.', ru: 'Исследуйте долину верхом с опытными гидами.', ky: 'Тажрыйбалуу гиддер менен ат минип өрөөндү изилдеңиз.' },
    type: 'horse', difficulty: 'easy', duration: 180, maxParticipants: 8, price: 50, currency: 'USD',
  },
  {
    name: { en: 'Sunrise Photography Tour', ru: 'Фототур на рассвете', ky: 'Таңкы фототур' },
    description: { en: 'Capture the golden hour at the best viewpoints with a photography guide.', ru: 'Захватите золотой час на лучших точках с фотогидом.', ky: 'Фотогид менен эң жакшы көрүнүш жерлеринде алтын саатты тартыңыз.' },
    type: 'photo', difficulty: 'moderate', duration: 240, maxParticipants: 6, price: 45, currency: 'USD',
  },
  {
    name: { en: 'Alpine Climbing Introduction', ru: 'Введение в альпинизм', ky: 'Альпинизмге киришүү' },
    description: { en: 'Learn the basics of alpine climbing with certified instructors.', ru: 'Изучите основы альпинизма с сертифицированными инструкторами.', ky: 'Сертификаттуу инструкторлор менен альпинизмдин негиздерин үйрөнүңүз.' },
    type: 'climbing', difficulty: 'challenging', duration: 480, maxParticipants: 4, price: 120, currency: 'USD',
  },
  {
    name: { en: 'Winter Ski Touring', ru: 'Зимний скитур', ky: 'Кышкы ски-тур' },
    description: { en: 'Backcountry ski touring through untouched powder.', ru: 'Скитур по нетронутому снегу.', ky: 'Тийилбеген кар аркылуу скитур.' },
    type: 'skiing', difficulty: 'moderate', duration: 300, maxParticipants: 6, price: 80, currency: 'USD',
  },
];

const parkConfig = {
  entryPrices: {
    citizen_adult: 100, citizen_child: 50, citizen_student: 70,
    tourist_adult: 500, tourist_child: 250, tourist_student: 350,
    currency: 'KGS',
  },
  parkCapacity: 2000,
  operatingHours: {
    summer: { open: '06:00', close: '21:00' },
    winter: { open: '07:00', close: '18:00' },
  },
  gondola: {
    pricePerPerson: 500, currency: 'KGS',
    operatingHours: { open: '09:00', close: '17:00' },
    slotDuration: 30, capacityPerSlot: 20,
  },
  emergencyContacts: {
    parkRangers: '+996312123456',
    mountainRescue: '+996312654321',
    ambulance: '103',
    police: '102',
  },
};

async function seed() {
  console.log('Seeding Ala-Archa database...');

  const batch = db.batch();

  for (const acc of accommodations) {
    batch.set(db.collection('accommodations').doc(), acc);
  }

  for (const trail of trails) {
    batch.set(db.collection('trails').doc(), trail);
  }

  for (const tour of tours) {
    batch.set(db.collection('tours').doc(), tour);
  }

  batch.set(db.collection('park_config').doc('settings'), parkConfig);

  await batch.commit();
  console.log('Seed complete!');
}

seed().catch(console.error);
