import Link from "next/link";

const features = [
  {
    icon: "🎫",
    title: "Park Pass",
    titleRu: "Пропуск",
    desc: "Buy your entry pass online and skip the line with QR",
    descRu: "Купите пропуск онлайн и пройдите по QR-коду",
  },
  {
    icon: "🏔",
    title: "Stays",
    titleRu: "Жильё",
    desc: "A-Frame cabins, barnhouses, domes & mountain huts",
    descRu: "А-образные домики, барнхаусы, купола и горные хижины",
  },
  {
    icon: "🚡",
    title: "Gondola",
    titleRu: "Канатная дорога",
    desc: "Ride to 3,200m with panoramic Tien Shan views",
    descRu: "Подъём на 3200м с панорамным видом на Тянь-Шань",
  },
  {
    icon: "🤖",
    title: "AI Concierge",
    titleRu: "ИИ Консьерж",
    desc: "Chat with Archa to plan and book your perfect trip",
    descRu: "Пообщайтесь с Арчой для планирования идеального отдыха",
  },
  {
    icon: "🥾",
    title: "Tours",
    titleRu: "Туры",
    desc: "Guided hiking, horse treks, climbing & photography",
    descRu: "Пешие походы, конные прогулки, альпинизм и фотосафари",
  },
  {
    icon: "🗺",
    title: "Trail Maps",
    titleRu: "Карта троп",
    desc: "GPS-enabled maps with offline support",
    descRu: "GPS-карты с офлайн поддержкой",
  },
];

const accommodations = [
  { name: "Khan-Teniri Barnhouse", price: "$250", perk: "Free gondola", type: "Premium" },
  { name: "Alpine A-Frame", price: "$120", perk: "Forest setting", type: "Cozy" },
  { name: "Mountain Dome", price: "$90", perk: "Stargazing ceiling", type: "Unique" },
  { name: "ALTO Cabin", price: "$150", perk: "Modern comforts", type: "Modern" },
];

export default function Home() {
  return (
    <div className="min-h-screen">
      {/* Nav */}
      <nav className="fixed top-0 w-full bg-white/90 backdrop-blur-sm border-b z-50">
        <div className="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-[#1B4332] rounded-lg flex items-center justify-center">
              <span className="text-white text-sm font-bold">A</span>
            </div>
            <span className="font-bold text-lg text-[#1B4332]">Ала-Арча</span>
          </div>
          <div className="hidden md:flex items-center gap-8 text-sm text-gray-600">
            <a href="#stays" className="hover:text-[#1B4332]">Жильё</a>
            <a href="#trails" className="hover:text-[#1B4332]">Маршруты</a>
            <a href="#tours" className="hover:text-[#1B4332]">Туры</a>
            <a href="#contact" className="hover:text-[#1B4332]">Контакты</a>
          </div>
          <div className="flex items-center gap-3">
            <select className="text-sm border rounded-lg px-2 py-1">
              <option value="ru">RU</option>
              <option value="en">EN</option>
              <option value="ky">KY</option>
            </select>
            <button className="bg-[#1B4332] text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-[#2D6A4F] transition-colors">
              Войти
            </button>
          </div>
        </div>
      </nav>

      {/* Hero */}
      <section className="relative pt-16">
        <div className="bg-gradient-to-br from-[#1B4332] to-[#2D6A4F] text-white">
          <div className="max-w-7xl mx-auto px-6 py-24 md:py-36">
            <div className="max-w-2xl">
              <div className="inline-flex items-center gap-2 bg-white/10 rounded-full px-4 py-2 text-sm mb-6">
                <span className="w-2 h-2 bg-green-400 rounded-full animate-pulse" />
                Парк открыт · -3°C
              </div>
              <h1 className="text-4xl md:text-6xl font-bold mb-6 leading-tight">
                Национальный парк
                <br />
                <span className="text-[#D4A843]">Ала-Арча</span>
              </h1>
              <p className="text-lg text-green-100 mb-8 max-w-lg">
                Горный побег в 40 минутах от Бишкека. Бронируйте жильё, канатную
                дорогу и туры в одном приложении.
              </p>
              <div className="flex flex-col sm:flex-row gap-4">
                <button className="bg-[#D4A843] text-[#1B4332] px-8 py-3 rounded-xl font-semibold text-lg hover:bg-[#E8C976] transition-colors">
                  Забронировать визит
                </button>
                <button className="border-2 border-white/30 text-white px-8 py-3 rounded-xl font-semibold text-lg hover:bg-white/10 transition-colors">
                  Маршруты
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Grid */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-6">
          <h2 className="text-3xl font-bold text-center mb-4">Всё в одном месте</h2>
          <p className="text-gray-500 text-center mb-12 max-w-lg mx-auto">
            От входного билета до горной вершины — планируйте весь отдых в нашем приложении
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {features.map((f) => (
              <div
                key={f.title}
                className="bg-white p-6 rounded-2xl border border-gray-200 hover:border-[#1B4332] hover:shadow-lg transition-all group"
              >
                <span className="text-4xl mb-4 block">{f.icon}</span>
                <h3 className="font-semibold text-lg mb-2 group-hover:text-[#1B4332]">
                  {f.titleRu}
                </h3>
                <p className="text-gray-500 text-sm">{f.descRu}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Accommodations */}
      <section id="stays" className="py-20">
        <div className="max-w-7xl mx-auto px-6">
          <h2 className="text-3xl font-bold mb-4">Где остановиться</h2>
          <p className="text-gray-500 mb-12">От уютных домиков до премиум барнхаусов</p>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {accommodations.map((a) => (
              <div
                key={a.name}
                className="group rounded-2xl border border-gray-200 overflow-hidden hover:shadow-lg transition-all"
              >
                <div className="h-48 bg-gradient-to-br from-[#1B4332]/10 to-[#2D6A4F]/5 flex items-center justify-center">
                  <span className="text-6xl opacity-20">🏔</span>
                </div>
                <div className="p-5">
                  <span className="text-xs font-medium text-[#D4A843] bg-[#D4A843]/10 px-2 py-1 rounded-full">
                    {a.type}
                  </span>
                  <h3 className="font-semibold mt-3 mb-1">{a.name}</h3>
                  <p className="text-sm text-gray-500 mb-3">{a.perk}</p>
                  <div className="flex items-center justify-between">
                    <span className="text-xl font-bold text-[#1B4332]">
                      {a.price}
                      <span className="text-sm font-normal text-gray-400">
                        /ночь
                      </span>
                    </span>
                    <button className="text-sm font-medium text-[#1B4332] hover:underline">
                      Забронировать →
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* AI Concierge CTA */}
      <section className="py-20 bg-[#1B4332]">
        <div className="max-w-4xl mx-auto px-6 text-center text-white">
          <div className="w-20 h-20 bg-white/10 rounded-2xl flex items-center justify-center mx-auto mb-6">
            <span className="text-4xl">🤖</span>
          </div>
          <h2 className="text-3xl font-bold mb-4">Познакомьтесь с Арчой</h2>
          <p className="text-green-200 mb-8 max-w-lg mx-auto">
            Наш ИИ-консьерж поможет спланировать идеальный визит. Спросите о наличии
            мест, забронируйте жильё или узнайте о маршрутах — всё в чате.
          </p>
          <button className="bg-[#D4A843] text-[#1B4332] px-8 py-3 rounded-xl font-semibold text-lg hover:bg-[#E8C976] transition-colors">
            Начать чат с Арчой
          </button>
        </div>
      </section>

      {/* Footer */}
      <footer id="contact" className="bg-gray-900 text-gray-400 py-12">
        <div className="max-w-7xl mx-auto px-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div>
              <h4 className="text-white font-semibold mb-4">Ала-Арча</h4>
              <p className="text-sm">
                Национальный парк Ала-Арча, ущелье Ала-Арча, Кыргызстан
              </p>
              <p className="text-sm mt-2">+996 312 123456</p>
              <p className="text-sm">info@ala-archa.kg</p>
            </div>
            <div>
              <h4 className="text-white font-semibold mb-4">Навигация</h4>
              <div className="flex flex-col gap-2 text-sm">
                <a href="#" className="hover:text-white">Жильё</a>
                <a href="#" className="hover:text-white">Канатная дорога</a>
                <a href="#" className="hover:text-white">Маршруты</a>
                <a href="#" className="hover:text-white">Туры</a>
              </div>
            </div>
            <div>
              <h4 className="text-white font-semibold mb-4">Экстренная помощь</h4>
              <div className="flex flex-col gap-2 text-sm">
                <p>Рейнджеры: +996 312 123456</p>
                <p>Горные спасатели: +996 312 654321</p>
                <p>Скорая: 103</p>
              </div>
            </div>
          </div>
          <div className="border-t border-gray-800 mt-8 pt-8 text-sm text-center">
            2026 Ala-Archa National Park. All rights reserved.
          </div>
        </div>
      </footer>
    </div>
  );
}
