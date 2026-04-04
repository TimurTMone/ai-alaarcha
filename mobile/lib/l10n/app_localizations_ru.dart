// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Ала-Арча';

  @override
  String get welcome => 'Добро пожаловать в Ала-Арчу';

  @override
  String get welcomeSubtitle => 'Ваш горный отдых ждёт';

  @override
  String get home => 'Главная';

  @override
  String get explore => 'Маршруты';

  @override
  String get book => 'Бронь';

  @override
  String get chat => 'Чат';

  @override
  String get profile => 'Профиль';

  @override
  String get login => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String get continueWithApple => 'Продолжить с Apple';

  @override
  String get continueWithPhone => 'Продолжить с телефоном';

  @override
  String get orContinueWith => 'или продолжить с';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get verificationCode => 'Код подтверждения';

  @override
  String get sendCode => 'Отправить код';

  @override
  String get verify => 'Подтвердить';

  @override
  String get logout => 'Выйти';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageKyrgyz => 'Кыргызча';

  @override
  String get parkOpen => 'Парк открыт';

  @override
  String get parkClosed => 'Парк закрыт';

  @override
  String trailsStatus(String status) {
    return 'Тропы: $status';
  }

  @override
  String get weather => 'Погода';

  @override
  String temperature(String degrees) {
    return '$degrees°C';
  }

  @override
  String get buyPass => 'Купить пропуск';

  @override
  String get myPasses => 'Мои пропуска';

  @override
  String get dayPass => 'Дневной пропуск';

  @override
  String get multiDayPass => 'Многодневный пропуск';

  @override
  String get annualPass => 'Годовой пропуск';

  @override
  String get citizen => 'Гражданин';

  @override
  String get tourist => 'Турист';

  @override
  String get child => 'Ребёнок';

  @override
  String get student => 'Студент';

  @override
  String validUntil(String date) {
    return 'Действителен до $date';
  }

  @override
  String get showQR => 'Показать QR-код';

  @override
  String get passActive => 'Активный';

  @override
  String get passUsed => 'Использован';

  @override
  String get passExpired => 'Истёк';

  @override
  String get accommodations => 'Жильё';

  @override
  String get viewAll => 'Смотреть все';

  @override
  String get bookNow => 'Забронировать';

  @override
  String get perNight => '/ ночь';

  @override
  String get guests => 'Гости';

  @override
  String get checkIn => 'Заезд';

  @override
  String get checkOut => 'Выезд';

  @override
  String nightCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ночей',
      few: '$count ночи',
      one: '1 ночь',
    );
    return '$_temp0';
  }

  @override
  String get amenities => 'Удобства';

  @override
  String get reviews => 'Отзывы';

  @override
  String get includesGondola => 'Бесплатный доступ к канатной дороге';

  @override
  String get availability => 'Доступность';

  @override
  String get selectDates => 'Выбрать даты';

  @override
  String get confirmBooking => 'Подтвердить бронь';

  @override
  String get bookingConfirmed => 'Бронь подтверждена!';

  @override
  String get bookingPending => 'Ожидает подтверждения';

  @override
  String get restaurants => 'Рестораны';

  @override
  String get reserveTable => 'Забронировать стол';

  @override
  String get menu => 'Меню';

  @override
  String get partySize => 'Количество гостей';

  @override
  String get timeSlot => 'Время';

  @override
  String get specialRequests => 'Особые пожелания';

  @override
  String get gondola => 'Канатная дорога';

  @override
  String get bookGondola => 'Забронировать подъём';

  @override
  String get passengers => 'Пассажиры';

  @override
  String get gondolaOperational => 'Работает';

  @override
  String get gondolaDelayed => 'Задержка';

  @override
  String get gondolaClosed => 'Закрыта из-за погоды';

  @override
  String get freeWithStay => 'Бесплатно с проживанием';

  @override
  String get tours => 'Туры';

  @override
  String get bookTour => 'Забронировать тур';

  @override
  String get difficulty => 'Сложность';

  @override
  String get duration => 'Продолжительность';

  @override
  String get maxParticipants => 'Макс. участников';

  @override
  String get guide => 'Гид';

  @override
  String hoursCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часов',
      few: '$count часа',
      one: '1 час',
    );
    return '$_temp0';
  }

  @override
  String get trails => 'Тропы';

  @override
  String get trailMap => 'Карта троп';

  @override
  String get elevation => 'Высота';

  @override
  String get distance => 'Расстояние';

  @override
  String get estimatedTime => 'Примерное время';

  @override
  String get trailOpen => 'Открыта';

  @override
  String get trailCaution => 'Осторожно';

  @override
  String get trailClosed => 'Закрыта';

  @override
  String get downloadOffline => 'Скачать для офлайн';

  @override
  String get startNavigation => 'Начать навигацию';

  @override
  String get sauna => 'Сауна и SPA';

  @override
  String get bookSession => 'Забронировать сеанс';

  @override
  String get privateSession => 'Частный сеанс';

  @override
  String get groupSession => 'Групповой сеанс';

  @override
  String get sos => 'SOS';

  @override
  String get emergency => 'Экстренная помощь';

  @override
  String get sosButton => 'Отправить сигнал SOS';

  @override
  String get sosConfirm => 'Вы уверены, что хотите отправить сигнал SOS?';

  @override
  String get sosSent => 'Сигнал отправлен! Помощь в пути.';

  @override
  String get callRangers => 'Позвонить рейнджерам';

  @override
  String get callRescue => 'Позвонить горным спасателям';

  @override
  String get aiConcierge => 'Арча ИИ';

  @override
  String get aiWelcome => 'Привет! Я Арча, ваш горный гид. Чем могу помочь?';

  @override
  String get typeMessage => 'Введите сообщение...';

  @override
  String get uploadReceipt => 'Загрузить чек';

  @override
  String get payment => 'Оплата';

  @override
  String get payWithCard => 'Оплатить картой';

  @override
  String get payWithMbank => 'Оплатить через Mbank';

  @override
  String get payWithOdengi => 'Оплатить через O!Dengi';

  @override
  String get uploadBankReceipt => 'Загрузить банковский чек';

  @override
  String get total => 'Итого';

  @override
  String get currency => 'сом';

  @override
  String get myBookings => 'Мои бронирования';

  @override
  String get upcoming => 'Предстоящие';

  @override
  String get past => 'Прошедшие';

  @override
  String get cancelled => 'Отменённые';

  @override
  String get cancelBooking => 'Отменить бронь';

  @override
  String get cancelConfirm => 'Вы уверены, что хотите отменить бронирование?';

  @override
  String get settings => 'Настройки';

  @override
  String get notifications => 'Уведомления';

  @override
  String get language => 'Язык';

  @override
  String get aboutPark => 'О парке';

  @override
  String get contactUs => 'Связаться с нами';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Что-то пошло не так';

  @override
  String get retry => 'Повторить';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get save => 'Сохранить';

  @override
  String get done => 'Готово';

  @override
  String get next => 'Далее';

  @override
  String get back => 'Назад';

  @override
  String get search => 'Поиск';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get seeMore => 'Ещё';
}
