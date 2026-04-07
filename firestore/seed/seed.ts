import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

// Run: npx ts-node firestore/seed/seed.ts
// Requires GOOGLE_APPLICATION_CREDENTIALS env var or service account

initializeApp();
const db = getFirestore();

// ═══════════════════════════════════════════════════════════════
// SERVICES — from alaarchapark.com/services + news sources
// All prices in KGS (whole som). Trilingual names.
// ═══════════════════════════════════════════════════════════════

// Images from alaarchapark.com
const IMG = {
  // A-Frame real photos from alaarchapark.com
  aframe01: 'https://alaarchapark.com/_next/static/media/01-hero.c7f8f70f.jpg',
  aframe07: 'https://alaarchapark.com/_next/static/media/07.d18723cb.jpg',
  aframe08: 'https://alaarchapark.com/_next/static/media/08.f9f99b5d.jpg',
  // Hotels
  hotelResort1: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
  hotelResort2: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
  ecoLodge1: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
  ecoLodge2: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
  cabin1: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
  // Services
  restaurant1: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
  restaurant2: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
  sauna1: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
  sauna2: 'https://images.unsplash.com/photo-1551524164-687a55dd1126?w=800',
  confHall1: 'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800',
  confHall2: 'https://images.unsplash.com/photo-1515165562835-c3b8c6d0b7b5?w=800',
  bikeRental1: 'https://images.unsplash.com/photo-1520975958225-6b1c0b22d7ae?w=800',
  // General
  mountains: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
  peaks: 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800',
  forest: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
  bookingCabin: 'https://images.unsplash.com/photo-1501556424050-d4816356e4f7?w=800',
  parkScenery: 'https://alaarchapark.kg/wp-content/uploads/2022/08/1-1024x682.jpeg',
  snowMountain: 'https://images.unsplash.com/photo-1549880338-65ddcdfd017b?w=800',
};

const services = [
  // ── ENTRANCE ──
  {
    id: 's-entrance-adult',
    name: { en: 'Adult Entry', ru: 'Вход (взрослый)', ky: 'Кирүү (чоң киши)' },
    description: { en: 'Per person entry fee (adults)', ru: 'Входной билет с человека (взрослый)', ky: 'Бир чоң кишиге кирүү акысы' },
    category: 'entrance', priceKgs: 200, unit: 'perPerson', images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'https://alaarchapark.kg/wp-content/uploads/2022/08/1-1024x682.jpeg'], isActive: true,
  },
  {
    id: 's-entrance-child',
    name: { en: 'Child Entry (7–14)', ru: 'Вход (ребёнок 7–14)', ky: 'Кирүү (бала 7–14)' },
    description: { en: 'Per child (7–14 years)', ru: 'Входной билет для детей 7–14 лет', ky: '7–14 жаштагы балдар үчүн' },
    category: 'entrance', priceKgs: 150, unit: 'perPerson', images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true,
  },
  {
    id: 's-entrance-electric-vehicle',
    name: { en: 'Electric Vehicle Entry', ru: 'Въезд электромобиля', ky: 'Электромобиль кирүү' },
    description: { en: 'Entry for electric vehicles only (gas/diesel prohibited since May 2025)', ru: 'Въезд для электромобилей (бензин/дизель запрещён с мая 2025)', ky: 'Электромобилдер үчүн гана (бензин/дизель тыюу)' },
    category: 'entrance', priceKgs: 800, unit: 'perVehicle', images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true,
  },
  {
    id: 's-entrance-gondola',
    name: { en: 'Gondola (round trip)', ru: 'Канатная дорога (туда-обратно)', ky: 'Канат жол (бара-кайтара)' },
    description: { en: 'Doppelmayr gondola, 1 km, 2166→2494 m. 16 cabins (10-seat + 2 VIP 4-seat). Cashless only.', ru: 'Гондола Doppelmayr, 1 км, 2166→2494 м. 16 кабин (10 мест + 2 VIP на 4). Только безнал.', ky: 'Doppelmayr гондоласы, 1 км, 2166→2494 м. 16 кабина (10 орун + 2 VIP 4 орун). Накталай эмес гана.' },
    category: 'entrance', priceKgs: 600, unit: 'perPerson', images: ['https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true,
  },
  {
    id: 's-entrance-gondola-child',
    name: { en: 'Gondola — Child (round trip)', ru: 'Канатная дорога — ребёнок', ky: 'Канат жол — бала' },
    description: { en: 'Round trip gondola ticket for children', ru: 'Проезд на канатной дороге для детей (туда-обратно)', ky: 'Балдар үчүн канат жолго билет (бара-кайтара)' },
    category: 'entrance', priceKgs: 400, unit: 'perPerson', images: ['https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800'], isActive: true,
  },

  // ── KHAN-TENIRI ──
  {
    id: 's-kt-barnhouse',
    name: { en: 'Khan-Teniri Barnhouse', ru: 'Барнхаус Khan-Teniri', ky: 'Khan-Teniri барнхаусу' },
    description: { en: 'Modern barnhouse with sauna & jacuzzi. Free gondola for guests. $250/night.', ru: 'Современный барнхаус с сауной и джакузи. Бесплатная канатка для гостей. $250/ночь.', ky: 'Заманбап барнхаус, сауна жана джакузи. Конокторго канат жол акысыз. $250/түнгө.' },
    category: 'hotel', priceKgs: 21500, unit: 'perNight', capacity: 4, venue: 'Khan-Teniri', images: ['https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true,
  },

  // ── HOTELS ──
  {
    id: 's-hotel-ala-archa-7',
    name: { en: 'Suite #7', ru: 'Люкс №7', ky: 'Люкс №7' },
    description: { en: 'Double room, breakfast included', ru: 'Двухместный, завтрак включён', ky: 'Эки кишилик, эртең мененки тамак менен' },
    category: 'hotel', priceKgs: 9000, unit: 'perNight', capacity: 2, venue: 'Ala-Archa Hotel', phone: '+996 701 551 026', images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800'], isActive: true,
  },
  {
    id: 's-hotel-ala-archa-5-6',
    name: { en: 'Junior Suite #5–6', ru: 'Полулюкс №5–6', ky: 'Жарым люкс №5–6' },
    description: { en: 'Double room, breakfast included', ru: 'Двухместный, завтрак включён', ky: 'Эки кишилик, эртең мененки тамак менен' },
    category: 'hotel', priceKgs: 6000, unit: 'perNight', capacity: 2, venue: 'Ala-Archa Hotel', phone: '+996 701 551 026', images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800'], isActive: true,
  },
  {
    id: 's-hotel-ala-archa-8',
    name: { en: 'Room #8', ru: 'Номер №8', ky: 'Номер №8' },
    description: { en: 'Quad room, breakfast included', ru: 'Четырёхместный, завтрак включён', ky: 'Төрт кишилик, эртең мененки тамак менен' },
    category: 'hotel', priceKgs: 7000, unit: 'perNight', capacity: 4, venue: 'Ala-Archa Hotel', phone: '+996 701 551 026', images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'], isActive: true,
  },
  {
    id: 's-hotel-ala-archa-1-4',
    name: { en: 'Rooms #1–4', ru: 'Номера №1–4', ky: 'Номерлер №1–4' },
    description: { en: 'Double room, breakfast included', ru: 'Двухместный, завтрак включён', ky: 'Эки кишилик, эртең мененки тамак менен' },
    category: 'hotel', priceKgs: 4000, unit: 'perNight', capacity: 2, venue: 'Ala-Archa Hotel', phone: '+996 701 551 026', images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'], isActive: true,
  },
  {
    id: 's-hotel-ala-archa-mattress',
    name: { en: 'Extra Mattress with Bedding', ru: 'Доп. матрас с бельём', ky: 'Кошумча матрас менен төшөк' },
    description: { en: 'Additional mattress in shared room', ru: 'Дополнительный матрас в номере', ky: 'Номерге кошумча матрас' },
    category: 'hotel', priceKgs: 500, unit: 'perNight', venue: 'Ala-Archa Hotel', phone: '+996 701 551 026', images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'], isActive: true,
  },
  {
    id: 's-hotel-akmaral',
    name: { en: 'Rooms #1–3', ru: 'Номера №1–3', ky: 'Номерлер №1–3' },
    description: { en: 'Double rooms (Room #2 has large hall, Room #3 has small hall for 4)', ru: 'Двухместные номера (№2 с большим залом, №3 с малым залом на 4)', ky: 'Эки кишилик номерлер (№2 чоң зал, №3 4 кишиге кичи зал)' },
    category: 'hotel', priceKgs: 4000, unit: 'perNight', capacity: 2, venue: 'Ak-Maral Hotel', phone: '+996 505 960 097', images: ['https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800'], isActive: true,
  },
  {
    id: 's-hotel-akbata-junior',
    name: { en: 'Junior Suite #3–6', ru: 'Полулюкс №3–6', ky: 'Жарым люкс №3–6' },
    description: { en: 'Double room, breakfast included', ru: 'Двухместный, завтрак включён', ky: 'Эки кишилик, эртең мененки тамак менен' },
    category: 'hotel', priceKgs: 7000, unit: 'perNight', capacity: 2, venue: 'Ak-Bata Hotel', phone: '+996 500 417 741', images: ['https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true,
  },
  {
    id: 's-hotel-akbata-suite',
    name: { en: 'Suite #1, #2, #7, #8', ru: 'Люкс №1, 2, 7, 8', ky: 'Люкс №1, 2, 7, 8' },
    description: { en: 'Double room, breakfast included', ru: 'Двухместный, завтрак включён', ky: 'Эки кишилик, эртең мененки тамак менен' },
    category: 'hotel', priceKgs: 5000, unit: 'perNight', capacity: 2, venue: 'Ak-Bata Hotel', phone: '+996 500 417 741', images: ['https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true,
  },

  // ── VENUE HALLS ──
  { id: 's-hall-conf-30', name: { en: 'Conference Hall (30 seats)', ru: 'Конференц-зал (30 мест)', ky: 'Конференц-зал (30 орун)' }, description: { en: 'First hour 2,000 KGS; each additional 1,000 KGS', ru: 'Первый час 2 000; далее 1 000 сом/час', ky: 'Биринчи саат 2 000; кийинкиси 1 000 сом' }, category: 'venue', priceKgs: 2000, unit: 'perHour', capacity: 30, images: ['https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800', 'https://images.unsplash.com/photo-1515165562835-c3b8c6d0b7b5?w=800'], isActive: true },
  { id: 's-hall-banquet-10', name: { en: 'Banquet Hall (10 seats)', ru: 'Банкетный зал (10 мест)', ky: 'Банкет залы (10 орун)' }, description: { en: 'First hour 500 KGS; each additional 250 KGS', ru: 'Первый час 500; далее 250 сом/час', ky: 'Биринчи саат 500; кийинкиси 250 сом' }, category: 'venue', priceKgs: 500, unit: 'perHour', capacity: 10, images: ['https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800'], isActive: true },
  { id: 's-hall-banquet-30', name: { en: 'Banquet Hall (30 seats)', ru: 'Банкетный зал (30 мест)', ky: 'Банкет залы (30 орун)' }, description: { en: 'First hour 2,000 KGS; each additional 500 KGS', ru: 'Первый час 2 000; далее 500 сом/час', ky: 'Биринчи саат 2 000; кийинкиси 500 сом' }, category: 'venue', priceKgs: 2000, unit: 'perHour', capacity: 30, images: ['https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800', 'https://images.unsplash.com/photo-1515165562835-c3b8c6d0b7b5?w=800'], isActive: true },
  { id: 's-hall-fireplace', name: { en: 'Fireplace Hall (10 seats)', ru: 'Каминный зал (10 мест)', ky: 'Камин залы (10 орун)' }, description: { en: 'First hour 1,000 KGS; each additional 500 KGS', ru: 'Первый час 1 000; далее 500 сом/час', ky: 'Биринчи саат 1 000; кийинкиси 500 сом' }, category: 'venue', priceKgs: 1000, unit: 'perHour', capacity: 10, images: ['https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800'], isActive: true },
  { id: 's-hall-yurt-national', name: { en: 'National Yurt (15 seats)', ru: 'Национальная юрта (15 мест)', ky: 'Улуттук боз үй (15 орун)' }, description: { en: 'First hour 1,000 KGS; each additional 500 KGS', ru: 'Первый час 1 000; далее 500 сом/час', ky: 'Биринчи саат 1 000; кийинкиси 500 сом' }, category: 'venue', priceKgs: 1000, unit: 'perHour', capacity: 15, images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true },
  { id: 's-hall-akbata-45', name: { en: 'Conference Hall (45 seats)', ru: 'Конференц-зал (45 мест)', ky: 'Конференц-зал (45 орун)' }, description: { en: 'Flat hourly rate', ru: 'Фиксированная ставка за час', ky: 'Бекитилген сааттык тариф' }, category: 'venue', priceKgs: 4000, unit: 'perHour', capacity: 45, venue: 'Ak-Bata', images: ['https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800', 'https://images.unsplash.com/photo-1515165562835-c3b8c6d0b7b5?w=800'], isActive: true },
  { id: 's-hall-akbata-70', name: { en: 'Conference Hall (70 seats)', ru: 'Конференц-зал (70 мест)', ky: 'Конференц-зал (70 орун)' }, description: { en: 'Flat hourly rate', ru: 'Фиксированная ставка за час', ky: 'Бекитилген сааттык тариф' }, category: 'venue', priceKgs: 5000, unit: 'perHour', capacity: 70, venue: 'Ak-Bata', images: ['https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800', 'https://images.unsplash.com/photo-1515165562835-c3b8c6d0b7b5?w=800'], isActive: true },

  // ── RECREATION ──
  { id: 's-rec-aframe', name: { en: 'A-Frame Cottage', ru: 'А-коттедж', ky: 'А-коттедж' }, description: { en: '4 guests, guests bring their own meals', ru: '4 гостя, еду гости приносят сами', ky: '4 коноктун тамагын өздөрү алып келет' }, category: 'recreation', priceKgs: 8850, unit: 'perNight', capacity: 4, phone: '+996 550 133 603', images: ['https://alaarchapark.com/_next/static/media/07.d18723cb.jpg', 'https://alaarchapark.com/_next/static/media/08.f9f99b5d.jpg', 'https://alaarchapark.com/_next/static/media/01-hero.c7f8f70f.jpg', 'https://alaarchapark.com/_next/static/media/02-hero.8a8c6f87.jpg', 'https://alaarchapark.com/_next/static/media/03-exterior.ba144427.jpg', 'https://alaarchapark.com/_next/static/media/05-interior.581b48b1.jpg', 'https://alaarchapark.com/_next/static/media/06-bedroom.21eae68c.jpg'], isActive: true },
  { id: 's-rec-forest-house', name: { en: 'House in the Forest', ru: '«Дом в лесу»', ky: '«Токойдогу үй»' }, description: { en: '16-person hall, bedroom, kitchen', ru: 'Зал на 16 мест, спальня, кухня', ky: '16 орундуу зал, уктоочу бөлмө, ашкана' }, category: 'recreation', priceKgs: 2500, unit: 'perNight', capacity: 16, images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800', 'https://images.unsplash.com/photo-1501556424050-d4816356e4f7?w=800'], isActive: true },
  { id: 's-rec-simple-yurt', name: { en: 'Simple Yurt', ru: 'Простая юрта', ky: 'Жөнөкөй боз үй' }, description: { en: 'Traditional yurt for rent', ru: 'Традиционная юрта в аренду', ky: 'Салттуу боз үй ижарага' }, category: 'recreation', priceKgs: 1000, unit: 'perNight', images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true },
  { id: 's-rec-summer-cottage', name: { en: 'Summer Cottages', ru: 'Летние коттеджи', ky: 'Жайкы коттедждер' }, description: { en: 'Per-room rate', ru: 'За каждый номер', ky: 'Ар бир номер үчүн' }, category: 'recreation', priceKgs: 6000, unit: 'perNight', images: ['https://images.unsplash.com/photo-1501556424050-d4816356e4f7?w=800', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },
  { id: 's-rec-canopy', name: { en: 'Summer Canopy', ru: 'Летний навес', ky: 'Жайкы навес' }, description: { en: '6 hours, table service for 10', ru: '6 часов, стол на 10 человек', ky: '6 саат, 10 кишиге үстөл' }, category: 'recreation', priceKgs: 400, unit: 'perTable', capacity: 10, images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },
  { id: 's-rec-botanik', name: { en: 'Botanik', ru: '«Ботаник»', ky: '«Ботаник»' }, description: { en: '16-person hall, bedroom, kitchen', ru: 'Зал на 16 мест, спальня, кухня', ky: '16 орундуу зал, уктоочу бөлмө, ашкана' }, category: 'recreation', priceKgs: 2000, unit: 'perNight', capacity: 16, images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800', 'https://images.unsplash.com/photo-1501556424050-d4816356e4f7?w=800'], isActive: true },
  { id: 's-rec-cafebar', name: { en: 'Cafe-Bars Adygene & Boyrok', ru: 'Кафе-бары «Адыгене» и «Бойрок»', ky: '«Адыгене» жана «Бойрок» кафе-барлары' }, description: { en: 'Per table, per day', ru: 'За стол, в день', ky: 'Бир үстөлгө, күнүнө' }, category: 'recreation', priceKgs: 400, unit: 'perTable', phone: '+996 702 150 976', images: ['https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800', 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800'], isActive: true },
  { id: 's-rec-alplager', name: { en: 'Alplager Canteen', ru: 'Столовая «Альплагерь»', ky: '«Альплагерь» ашканасы' }, description: { en: 'Per table, per day', ru: 'За стол, в день', ky: 'Бир үстөлгө, күнүнө' }, category: 'recreation', priceKgs: 400, unit: 'perTable', images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800'], isActive: true },
  { id: 's-rec-salkyn-tor', name: { en: 'Gazebo Salkyn-Tor (50 seats)', ru: 'Беседка «Салкын-Тор» (50 мест)', ky: '«Салкын-Тор» беседкасы (50 орун)' }, description: { en: '1,500 KGS/table; +1,000 each additional hour; 6,000 for 5+ hours', ru: '1 500 сом/стол; +1 000 сом/час; 6 000 сом за 5+ часов', ky: '1 500 сом/үстөл; +1 000 сом/саат; 6 000 сом 5+ саатка' }, category: 'recreation', priceKgs: 1500, unit: 'perTable', capacity: 50, images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },

  // ── RENTALS / ACTIVITIES ──
  { id: 's-rent-sauna', name: { en: 'Sauna', ru: 'Сауна', ky: 'Сауна' }, description: { en: 'Per person, per hour', ru: 'С человека в час', ky: 'Бир кишиге, сааттык' }, category: 'rental', priceKgs: 200, unit: 'perHour', phone: '+996 999 380 280', images: ['https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800', 'https://images.unsplash.com/photo-1551524164-687a55dd1126?w=800'], isActive: true },
  { id: 's-rent-horse', name: { en: 'Horse Riding', ru: 'Конные прогулки', ky: 'Ат минүү' }, description: { en: 'Per horse, per hour', ru: 'За лошадь в час', ky: 'Бир атка, сааттык' }, category: 'rental', priceKgs: 400, unit: 'perHour', images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },
  { id: 's-rent-skating', name: { en: 'Ice Skating', ru: 'Катание на коньках', ky: 'Коньки тебүү' }, description: { en: 'Per person, per hour', ru: 'С человека в час', ky: 'Бир кишиге, сааттык' }, category: 'rental', priceKgs: 100, unit: 'perHour', images: ['https://images.unsplash.com/photo-1549880338-65ddcdfd017b?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true },
  { id: 's-rent-guide', name: { en: 'Guide Services', ru: 'Услуги гида', ky: 'Гид кызматы' }, description: { en: 'Per hour', ru: 'За час', ky: 'Бир саатка' }, category: 'rental', priceKgs: 300, unit: 'perHour', images: ['https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true },
  { id: 's-rent-tapchan', name: { en: 'Tapchan', ru: 'Аренда тапчана', ky: 'Тапчан ижарасы' }, description: { en: 'Per hour', ru: 'За час', ky: 'Бир саатка' }, category: 'rental', priceKgs: 200, unit: 'perHour', images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },

  // ── EXTRAS ──
  { id: 's-extra-museum-adult', name: { en: 'Museum Visit (adult)', ru: 'Посещение музея (взрослый)', ky: 'Музейге баруу (чоң киши)' }, description: { en: 'Per person', ru: 'С человека', ky: 'Бир кишиге' }, category: 'extra', priceKgs: 50, unit: 'perPerson', images: ['https://alaarchapark.kg/wp-content/uploads/2022/08/1-1024x682.jpeg'], isActive: true },
  { id: 's-extra-museum-child', name: { en: 'Museum Visit (child under 12)', ru: 'Посещение музея (до 12)', ky: 'Музейге баруу (12 жашка чейин)' }, description: { en: 'Per child', ru: 'За ребёнка', ky: 'Бир балага' }, category: 'extra', priceKgs: 20, unit: 'perPerson', images: ['https://alaarchapark.kg/wp-content/uploads/2022/08/1-1024x682.jpeg'], isActive: true },
  { id: 's-extra-dishes', name: { en: 'Dishes & Cutlery', ru: 'Посуда и приборы', ky: 'Идиш-аяк' }, description: { en: '4 hours, set for 10', ru: '4 часа, набор на 10 человек', ky: '4 саатка, 10 кишиге' }, category: 'extra', priceKgs: 250, unit: 'flat', images: ['https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800'], isActive: true },
  { id: 's-extra-cauldron', name: { en: 'Cauldron', ru: 'Казан', ky: 'Казан' }, description: { en: '4 hours', ru: '4 часа', ky: '4 саатка' }, category: 'extra', priceKgs: 250, unit: 'flat', images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },
  { id: 's-extra-grill', name: { en: 'Grill', ru: 'Мангал', ky: 'Мангал' }, description: { en: '4 hours', ru: '4 часа', ky: '4 саатка' }, category: 'extra', priceKgs: 200, unit: 'flat', images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },
  { id: 's-extra-kitchen', name: { en: 'Kitchen Access', ru: 'Аренда кухни', ky: 'Ашкана ижарасы' }, description: { en: '4 hours of cooking access', ru: '4 часа, готовка', ky: '4 саат, тамак жасоо' }, category: 'extra', priceKgs: 2000, unit: 'flat', images: ['https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800'], isActive: true },
  { id: 's-extra-cooking', name: { en: 'Cooking from Your Ingredients', ru: 'Готовка из продуктов гостя', ky: 'Коноктун азыктарынан тамак жасоо' }, description: { en: 'Per portion', ru: 'За порцию', ky: 'Бир порцияга' }, category: 'extra', priceKgs: 50, unit: 'perItem', images: ['https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800'], isActive: true },
  { id: 's-extra-hearth', name: { en: 'Hearth with Cauldron', ru: 'Очаг с казаном', ky: 'Казан менен очок' }, description: { en: 'Per hour', ru: 'За час', ky: 'Бир саатка' }, category: 'extra', priceKgs: 100, unit: 'perHour', images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },
  { id: 's-extra-storage', name: { en: 'Luggage Storage', ru: 'Камера хранения', ky: 'Жүк сактоочу' }, description: { en: 'Up to 20 kg, per day', ru: 'До 20 кг, в день', ky: '20 кгга чейин, күнүнө' }, category: 'extra', priceKgs: 200, unit: 'perDay', images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'], isActive: true },
  { id: 's-extra-tent', name: { en: 'Tent Setup', ru: 'Установка палатки', ky: 'Чатыр коюу' }, description: { en: 'Per day', ru: 'В день', ky: 'Күнүнө' }, category: 'extra', priceKgs: 200, unit: 'perDay', images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800'], isActive: true },
  { id: 's-extra-yurt-setup', name: { en: 'Yurt Setup', ru: 'Установка юрты', ky: 'Боз үй тигүү' }, description: { en: 'Per day', ru: 'В день', ky: 'Күнүнө' }, category: 'extra', priceKgs: 200, unit: 'perDay', images: ['https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true },
  { id: 's-extra-blankets', name: { en: 'Blankets', ru: 'Одеяла', ky: 'Жууркан' }, description: { en: '4 hours, 2 pieces', ru: '4 часа, 2 штуки', ky: '4 саат, 2 даана' }, category: 'extra', priceKgs: 200, unit: 'flat', images: ['https://images.unsplash.com/photo-1501556424050-d4816356e4f7?w=800'], isActive: true },
  { id: 's-extra-shower', name: { en: 'Shower', ru: 'Душ', ky: 'Душ' }, description: { en: 'Per person, per hour', ru: 'С человека в час', ky: 'Бир кишиге, сааттык' }, category: 'extra', priceKgs: 100, unit: 'perHour', images: ['https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800'], isActive: true },
  { id: 's-extra-restroom', name: { en: 'Restroom', ru: 'Туалет', ky: 'Даараткана' }, description: { en: 'Per person', ru: 'С человека', ky: 'Бир кишиге' }, category: 'extra', priceKgs: 10, unit: 'perPerson', images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'], isActive: true },
  { id: 's-extra-waiter', name: { en: 'Waiter Service', ru: 'Обслуживание официантом', ky: 'Официант кызматы' }, description: { en: '10% of order total', ru: '10% от суммы заказа', ky: 'Заказдын суммасынын 10%' }, category: 'extra', priceKgs: 0, unit: 'flat', images: ['https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800'], isActive: true },
];

// ═══════════════════════════════════════════════════════════════
// ACCOMMODATIONS
// ═══════════════════════════════════════════════════════════════

const accommodations = [
  {
    name: 'Khan-Teniri Barnhouse A',
    type: 'barnhouse',
    description: { en: 'Premium mountain barnhouse with panoramic views of the Tien Shan range', ru: 'Премиум горный барнхаус с панорамным видом на хребет Тянь-Шань', ky: 'Тянь-Шань кыркасынын панорамалык көрүнүшү менен премиум тоо барнхаусу' },
    capacity: 6, pricePerNight: 250, currency: 'USD',
    amenities: ['wifi', 'heating', 'kitchen', 'mountain_view', 'parking', 'sauna', 'jacuzzi'],
    includesGondola: true, images: [IMG.hotel, IMG.cabin, IMG.mountains], rating: 4.8, reviewCount: 24,
  },
  {
    name: 'Alpine A-Frame Cabin',
    type: 'a_frame',
    description: { en: 'Cozy A-frame cabin nestled in the alpine forest', ru: 'Уютный А-образный домик в горном лесу', ky: 'Тоо токойундагы жайлуу А-формадагы үй' },
    capacity: 4, pricePerNight: 120, currency: 'USD',
    amenities: ['heating', 'fireplace', 'kitchenette'],
    includesGondola: false, images: [IMG.cabin, IMG.forest], rating: 4.6, reviewCount: 18,
  },
  {
    name: 'Mountain Dome',
    type: 'dome',
    description: { en: 'Unique geodesic dome with transparent ceiling for stargazing', ru: 'Уникальный геодезический купол с прозрачным потолком для наблюдения за звёздами', ky: 'Жылдыздарды байкоо үчүн тунук шыптуу уникалдуу геодезиялык купол' },
    capacity: 3, pricePerNight: 90, currency: 'USD',
    amenities: ['transparent_ceiling', 'heating', 'bed'],
    includesGondola: false, images: [IMG.peaks, IMG.mountains], rating: 4.9, reviewCount: 31,
  },
  {
    name: 'ALTO Mountain Cabin',
    type: 'cabin',
    description: { en: 'Modern mountain cabin with all comforts of home', ru: 'Современная горная кабина со всеми удобствами', ky: 'Бардык ыңгайлуулуктары бар заманбап тоо кабинасы' },
    capacity: 4, pricePerNight: 150, currency: 'USD',
    amenities: ['wifi', 'heating', 'kitchen', 'hot_shower'],
    includesGondola: false, images: [IMG.cabin, IMG.hotel], rating: 4.7, reviewCount: 15,
  },
  {
    name: 'Rasek Mountain Hut',
    type: 'hut',
    description: { en: 'Base camp at 3,400m for mountaineers and serious trekkers', ru: 'Базовый лагерь на высоте 3400м для альпинистов', ky: 'Альпинисттер үчүн 3400м бийиктиктеги базалык лагерь' },
    capacity: 20, pricePerNight: 25, currency: 'USD',
    amenities: ['shared_bunks', 'basic_kitchen'],
    includesGondola: false, images: [IMG.peaks, IMG.mountains], rating: 4.3, reviewCount: 42,
  },
];

// ═══════════════════════════════════════════════════════════════
// TRAILS (from alaarchapark.com/map)
// ═══════════════════════════════════════════════════════════════

const trails = [
  { name: { en: 'Broken Heart Trail', ru: 'Тропа к Разбитому сердцу', ky: 'Сынган жүрөк жолу' }, description: { en: 'Easy scenic walk to the famous rock formation.', ru: 'Лёгкая прогулка к знаменитой скале.', ky: 'Белгилүү аскага жеңил жүрүш.' }, difficulty: '1B', distance: 2.4, elevationGain: 200, estimatedTime: 60, status: 'open', images: [IMG.mountains] },
  { name: { en: 'Tepshi Plateau Trail', ru: 'Тропа к плато Тепши', ky: 'Тепши түздүгүнө жол' }, description: { en: 'Easy hike to 2,580 m viewpoint.', ru: 'Лёгкий поход к смотровой на 2580 м.', ky: '2580 м көрүнүш жерине жеңил жүрүш.' }, difficulty: '1B', distance: 2.0, elevationGain: 250, estimatedTime: 75, status: 'open', images: [IMG.peaks] },
  { name: { en: 'Ak-Sai Waterfall Trail', ru: 'Тропа к водопаду Ак-Сай', ky: 'Ак-Сай шаркыратма жолу' }, description: { en: 'Moderate hike to the stunning Ak-Sai glacier waterfall at 2,860 m.', ru: 'Умеренный поход к водопаду ледника Ак-Сай на 2860 м.', ky: 'Ак-Сай мөңгү шаркыратмасына 2860 м бийиктиктеги орточо жүрүш.' }, difficulty: '2A', distance: 3.9, elevationGain: 700, estimatedTime: 180, status: 'open', images: [IMG.mountains, IMG.peaks] },
  { name: { en: 'Ratsek Hut Approach', ru: 'Подход к хижине Рацека', ky: 'Рацек үңкүрүнө жол' }, description: { en: 'Hard approach to 3,380 m base camp. Requires proper equipment.', ru: 'Тяжёлый подход к базовому лагерю на 3380 м. Необходимо снаряжение.', ky: '3380 м базалык лагерге оор жол. Шаймандар зарыл.' }, difficulty: '3B', distance: 5.7, elevationGain: 1200, estimatedTime: 360, status: 'open', images: [IMG.peaks, IMG.mountains] },
  { name: { en: 'Riverside Nature Walk', ru: 'Прогулка вдоль реки', ky: 'Дарыя боюнча жүрүш' }, description: { en: 'Gentle walk along Ala-Archa river. Perfect for families.', ru: 'Спокойная прогулка вдоль реки Ала-Арча. Идеально для семей.', ky: 'Ала-Арча дарыясы боюнча жайбаракат жүрүш. Үй-бүлөлөр үчүн.' }, difficulty: '1B', distance: 3, elevationGain: 100, estimatedTime: 60, status: 'open', images: [IMG.forest] },
];

// ═══════════════════════════════════════════════════════════════
// TOURS
// ═══════════════════════════════════════════════════════════════

const tours = [
  { name: { en: 'Guided Day Hike to Ak-Sai Waterfall', ru: 'Поход к водопаду Ак-Сай с гидом', ky: 'Гид менен Ак-Сай шаркыратмасына жүрүш' }, description: { en: 'Full-day guided hike to the Ak-Sai waterfall with lunch included.', ru: 'Целодневный поход к водопаду Ак-Сай с обедом.', ky: 'Түшкү тамак менен Ак-Сай шаркыратмасына бүт күндүк жүрүш.' }, type: 'hiking', difficulty: 'moderate', duration: 360, maxParticipants: 12, price: 35, currency: 'USD' },
  { name: { en: 'Horse Trek Through the Valley', ru: 'Конная прогулка по долине', ky: 'Өрөөн аркылуу ат менен жүрүш' }, description: { en: 'Explore the valley on horseback with experienced guides.', ru: 'Исследуйте долину верхом с опытными гидами.', ky: 'Тажрыйбалуу гиддер менен ат минип өрөөндү изилдеңиз.' }, type: 'horse', difficulty: 'easy', duration: 180, maxParticipants: 8, price: 50, currency: 'USD' },
  { name: { en: 'Sunrise Photography Tour', ru: 'Фототур на рассвете', ky: 'Таңкы фототур' }, description: { en: 'Capture the golden hour at the best viewpoints.', ru: 'Захватите золотой час на лучших точках с фотогидом.', ky: 'Фотогид менен эң жакшы көрүнүш жерлеринде алтын саатты тартыңыз.' }, type: 'photo', difficulty: 'moderate', duration: 240, maxParticipants: 6, price: 45, currency: 'USD' },
  { name: { en: 'Alpine Climbing Introduction', ru: 'Введение в альпинизм', ky: 'Альпинизмге киришүү' }, description: { en: 'Learn the basics of alpine climbing with certified instructors.', ru: 'Изучите основы альпинизма с сертифицированными инструкторами.', ky: 'Сертификаттуу инструкторлор менен альпинизмдин негиздерин үйрөнүңүз.' }, type: 'climbing', difficulty: 'challenging', duration: 480, maxParticipants: 4, price: 120, currency: 'USD' },
  { name: { en: 'Winter Ski Touring', ru: 'Зимний скитур', ky: 'Кышкы ски-тур' }, description: { en: 'Backcountry ski touring through untouched powder.', ru: 'Скитур по нетронутому снегу.', ky: 'Тийилбеген кар аркылуу скитур.' }, type: 'skiing', difficulty: 'moderate', duration: 300, maxParticipants: 6, price: 80, currency: 'USD' },
];

// ═══════════════════════════════════════════════════════════════
// PARK CONFIG — updated with real 2025/2026 data
// ═══════════════════════════════════════════════════════════════

const parkConfig = {
  entryPrices: {
    adult: 200,
    child_7_14: 150,
    child_under_7: 0,
    electric_vehicle: 800,
    currency: 'KGS',
  },
  gondola: {
    adult: 600,
    child: 400,
    currency: 'KGS',
    operatingHours: { open: '10:00', close: '19:00' },
    closedDay: 'monday',
    cashlessOnly: true,
    specs: { length: 1000, lowerAltitude: 2166, upperAltitude: 2494, cabins: 16, capacityPerHour: 1000 },
  },
  operatingHours: {
    office: { open: '09:00', close: '17:30', closedDays: ['saturday', 'sunday'] },
    park: { summer: { open: '06:00', close: '21:00' }, winter: { open: '07:00', close: '18:00' } },
  },
  contacts: {
    mainPhone: '+996 777 212 798',
    email: 'alaarca555@gmail.com',
    altEmail: 'ala-archa@list.ru',
    checkpointPhone: '+996 312 883 205',
    address: 'Kyrgyz Republic, Chui region, Alamudun district, Kashka-Suu village',
    marketing: '+996 997 885 888',
  },
  emergencyContacts: {
    parkRangers: '+996 777 212 798',
    mountainRescue: '+996 312 883 205',
    ambulance: '103',
    police: '102',
  },
  parkCapacity: 6000, // up to 5-6k per day during peak
  rules: {
    gasVehiclesBanned: true,
    gasVehiclesBannedSince: '2025-05-01',
    parkingSpaces: 2500,
  },
};

// ═══════════════════════════════════════════════════════════════

async function seed() {
  console.log('Seeding Ala-Archa database...');

  const batch = db.batch();

  // Services — use the id field as the document ID for stable references
  for (const svc of services) {
    const { id, ...data } = svc;
    batch.set(db.collection('services').doc(id), data);
  }
  console.log(`  ${services.length} services`);

  for (const acc of accommodations) {
    batch.set(db.collection('accommodations').doc(), acc);
  }
  console.log(`  ${accommodations.length} accommodations`);

  for (const trail of trails) {
    batch.set(db.collection('trails').doc(), trail);
  }
  console.log(`  ${trails.length} trails`);

  for (const tour of tours) {
    batch.set(db.collection('tours').doc(), tour);
  }
  console.log(`  ${tours.length} tours`);

  batch.set(db.collection('park_config').doc('settings'), parkConfig);
  console.log('  park_config/settings');

  await batch.commit();
  console.log('Seed complete!');
}

seed().catch(console.error);
