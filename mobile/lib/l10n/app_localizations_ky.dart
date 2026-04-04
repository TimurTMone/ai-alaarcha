// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get appTitle => 'Ала-Арча';

  @override
  String get welcome => 'Ала-Арчага кош келиңиз';

  @override
  String get welcomeSubtitle => 'Тоолордогу эс алуу сизди күтөт';

  @override
  String get home => 'Башкы бет';

  @override
  String get explore => 'Маршруттар';

  @override
  String get book => 'Броньдоо';

  @override
  String get chat => 'Чат';

  @override
  String get profile => 'Профиль';

  @override
  String get login => 'Кирүү';

  @override
  String get signUp => 'Катталуу';

  @override
  String get continueWithGoogle => 'Google менен улантуу';

  @override
  String get continueWithApple => 'Apple менен улантуу';

  @override
  String get continueWithPhone => 'Телефон менен улантуу';

  @override
  String get orContinueWith => 'же улантуу';

  @override
  String get phoneNumber => 'Телефон номери';

  @override
  String get verificationCode => 'Текшерүү коду';

  @override
  String get sendCode => 'Код жиберүү';

  @override
  String get verify => 'Текшерүү';

  @override
  String get logout => 'Чыгуу';

  @override
  String get selectLanguage => 'Тилди тандаңыз';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageKyrgyz => 'Кыргызча';

  @override
  String get parkOpen => 'Парк ачык';

  @override
  String get parkClosed => 'Парк жабык';

  @override
  String trailsStatus(String status) {
    return 'Жолдор: $status';
  }

  @override
  String get weather => 'Аба ырайы';

  @override
  String temperature(String degrees) {
    return '$degrees°C';
  }

  @override
  String get buyPass => 'Пропуск сатып алуу';

  @override
  String get myPasses => 'Менин пропусктарым';

  @override
  String get dayPass => 'Күндүк пропуск';

  @override
  String get multiDayPass => 'Көп күндүк пропуск';

  @override
  String get annualPass => 'Жылдык пропуск';

  @override
  String get citizen => 'Жаран';

  @override
  String get tourist => 'Турист';

  @override
  String get child => 'Бала';

  @override
  String get student => 'Студент';

  @override
  String validUntil(String date) {
    return '$date чейин жарактуу';
  }

  @override
  String get showQR => 'QR кодду көрсөтүү';

  @override
  String get scanAtEntrance => 'Парк киришинде сканерлеңиз';

  @override
  String maxCapacity(int count) {
    return 'Макс. $count';
  }

  @override
  String get passActive => 'Активдүү';

  @override
  String get passUsed => 'Колдонулган';

  @override
  String get passExpired => 'Мөөнөтү бүткөн';

  @override
  String get accommodations => 'Жашоо жайлар';

  @override
  String get viewAll => 'Баарын көрүү';

  @override
  String get bookNow => 'Броньдоо';

  @override
  String get perNight => '/ түн';

  @override
  String get guests => 'Конокторr';

  @override
  String get checkIn => 'Кирүү';

  @override
  String get checkOut => 'Чыгуу';

  @override
  String nightCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count түн',
      one: '1 түн',
    );
    return '$_temp0';
  }

  @override
  String get amenities => 'Ыңгайлуулуктар';

  @override
  String get reviews => 'Пикирлер';

  @override
  String get includesGondola => 'Канаттуу жолго бекер кирүү';

  @override
  String get availability => 'Бош орундар';

  @override
  String get selectDates => 'Күндөрдү тандаңыз';

  @override
  String get confirmBooking => 'Бронду ырастоо';

  @override
  String get bookingConfirmed => 'Бронь ырасталды!';

  @override
  String get bookingPending => 'Күтүүдө';

  @override
  String get restaurants => 'Ресторандар';

  @override
  String get reserveTable => 'Стол броньдоо';

  @override
  String get menu => 'Меню';

  @override
  String get partySize => 'Коноктордун саны';

  @override
  String get timeSlot => 'Убакыт';

  @override
  String get specialRequests => 'Өзгөчө каалоолор';

  @override
  String get gondola => 'Канаттуу жол';

  @override
  String get bookGondola => 'Көтөрүлүүнү броньдоо';

  @override
  String get passengers => 'Жүргүнчүлөр';

  @override
  String get gondolaOperational => 'Иштеп жатат';

  @override
  String get gondolaDelayed => 'Кечигүү';

  @override
  String get gondolaClosed => 'Аба ырайына байланыштуу жабык';

  @override
  String get freeWithStay => 'Жашоо менен бекер';

  @override
  String get tours => 'Турлар';

  @override
  String get bookTour => 'Тур броньдоо';

  @override
  String get difficulty => 'Татаалдык';

  @override
  String get duration => 'Узактык';

  @override
  String get maxParticipants => 'Макс. катышуучулар';

  @override
  String get guide => 'Гид';

  @override
  String hoursCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count саат',
      one: '1 саат',
    );
    return '$_temp0';
  }

  @override
  String get trails => 'Жолдор';

  @override
  String get trailMap => 'Жолдордун картасы';

  @override
  String get elevation => 'Бийиктик';

  @override
  String get distance => 'Аралык';

  @override
  String get estimatedTime => 'Болжолдуу убакыт';

  @override
  String get trailOpen => 'Ачык';

  @override
  String get trailCaution => 'Этият болуңуз';

  @override
  String get trailClosed => 'Жабык';

  @override
  String get downloadOffline => 'Офлайн үчүн жүктөө';

  @override
  String get startNavigation => 'Навигацияны баштоо';

  @override
  String get sauna => 'Сауна жана SPA';

  @override
  String get bookSession => 'Сеанс броньдоо';

  @override
  String get privateSession => 'Жеке сеанс';

  @override
  String get groupSession => 'Топтук сеанс';

  @override
  String get sos => 'SOS';

  @override
  String get emergency => 'Шашылыш жардам';

  @override
  String get sosButton => 'SOS сигнал жиберүү';

  @override
  String get sosConfirm => 'SOS сигнал жибергиңиз келеби?';

  @override
  String get sosSent => 'Сигнал жиберилди! Жардам жолдо.';

  @override
  String get callRangers => 'Рейнджерлерге чалуу';

  @override
  String get callRescue => 'Тоо куткаруучуларына чалуу';

  @override
  String get aiConcierge => 'Арча ИИ';

  @override
  String get aiWelcome =>
      'Салам! Мен Арча, сиздин тоо гидиңиз. Кантип жардам бере алам?';

  @override
  String get typeMessage => 'Билдирүү жазыңыз...';

  @override
  String get uploadReceipt => 'Чек жүктөө';

  @override
  String get payment => 'Төлөм';

  @override
  String get payWithCard => 'Карта менен төлөө';

  @override
  String get payWithMbank => 'Mbank менен төлөө';

  @override
  String get payWithOdengi => 'O!Dengi менен төлөө';

  @override
  String get uploadBankReceipt => 'Банк чегин жүктөө';

  @override
  String get total => 'Жалпы';

  @override
  String get currency => 'сом';

  @override
  String get myBookings => 'Менин брондорум';

  @override
  String get upcoming => 'Алдыдагы';

  @override
  String get past => 'Өткөн';

  @override
  String get cancelled => 'Жокко чыгарылган';

  @override
  String get cancelBooking => 'Бронду жокко чыгаруу';

  @override
  String get cancelConfirm => 'Бронду жокко чыгаргыңыз келеби?';

  @override
  String get settings => 'Жөндөөлөр';

  @override
  String get notifications => 'Билдирмелер';

  @override
  String get language => 'Тил';

  @override
  String get aboutPark => 'Парк жөнүндө';

  @override
  String get contactUs => 'Байланыш';

  @override
  String get termsOfService => 'Колдонуу шарттары';

  @override
  String get privacyPolicy => 'Купуялык саясаты';

  @override
  String get loading => 'Жүктөлүүдө...';

  @override
  String get error => 'Ката кетти';

  @override
  String get retry => 'Кайталоо';

  @override
  String get cancel => 'Жокко чыгаруу';

  @override
  String get confirm => 'Ырастоо';

  @override
  String get save => 'Сактоо';

  @override
  String get done => 'Даяр';

  @override
  String get next => 'Кийинки';

  @override
  String get back => 'Артка';

  @override
  String get search => 'Издөө';

  @override
  String get noResults => 'Эч нерсе табылган жок';

  @override
  String get seeMore => 'Дагы';
}
