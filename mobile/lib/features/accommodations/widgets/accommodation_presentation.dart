import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/models/accommodation_model.dart';

abstract final class AccommodationPresentation {
  static IconData iconFor(AccommodationType type) => switch (type) {
    AccommodationType.aFrame => Icons.cabin_rounded,
    AccommodationType.barnhouse => Icons.holiday_village_rounded,
    AccommodationType.hotelRoom => Icons.hotel_rounded,
    AccommodationType.cabin => Icons.forest_rounded,
    AccommodationType.dome => Icons.night_shelter_rounded,
    AccommodationType.hut => Icons.home_work_rounded,
  };

  static List<Color> gradientFor(Accommodation accommodation) =>
      switch (accommodation.type) {
        AccommodationType.aFrame => const [
          Color(0xFF214E34),
          Color(0xFF3D7B59),
          Color(0xFF8AA66E),
        ],
        AccommodationType.barnhouse => const [
          Color(0xFF5B3722),
          Color(0xFF8C5A37),
          Color(0xFFD4A843),
        ],
        AccommodationType.hotelRoom => const [
          Color(0xFF183B54),
          Color(0xFF29648A),
          Color(0xFF67A7D8),
        ],
        AccommodationType.cabin => const [
          Color(0xFF274C36),
          Color(0xFF497A53),
          Color(0xFF9BC59D),
        ],
        AccommodationType.dome => const [
          Color(0xFF3A2F61),
          Color(0xFF5A4B91),
          Color(0xFF9CAAF0),
        ],
        AccommodationType.hut => const [
          Color(0xFF4D3A22),
          Color(0xFF7D5B33),
          Color(0xFFCAA36A),
        ],
      };

  static String typeLabel(AccommodationType type, String locale) {
    final labels = switch (type) {
      AccommodationType.aFrame => const {
        'en': 'A-Frame cottage',
        'ru': 'Коттедж A-Frame',
        'ky': 'A-Frame коттеджи',
      },
      AccommodationType.barnhouse => const {
        'en': 'Barnhouse',
        'ru': 'Барнхаус',
        'ky': 'Барнхаус',
      },
      AccommodationType.hotelRoom => const {
        'en': 'Hotel',
        'ru': 'Отель',
        'ky': 'Мейманкана',
      },
      AccommodationType.cabin => const {
        'en': 'Cabin',
        'ru': 'Коттедж',
        'ky': 'Коттедж',
      },
      AccommodationType.dome => const {
        'en': 'Dome',
        'ru': 'Купол',
        'ky': 'Купол',
      },
      AccommodationType.hut => const {'en': 'Hut', 'ru': 'Домик', 'ky': 'Үй'},
    };
    return labels[locale] ?? labels['ru']!;
  }

  static String? primaryImage(Accommodation accommodation) =>
      accommodation.images.isNotEmpty ? accommodation.images.first : null;

  static String priceLabel(Accommodation accommodation) =>
      formatAmount(accommodation.pricePerNight, accommodation.currency);

  static String formatAmount(num amount, String currency) {
    final formatted = _formatNumber(amount.round());
    return switch (currency.toUpperCase()) {
      'USD' => '\$$formatted',
      'KGS' => '$formatted сом',
      _ => '$formatted $currency',
    };
  }

  static String perNightLabel(String locale) =>
      {'en': 'per night', 'ru': 'за ночь', 'ky': 'бир түнгө'}[locale] ??
      'за ночь';

  static String guestCapacityLabel(int capacity, String locale) {
    return switch (locale) {
      'en' => '$capacity guests',
      'ky' => '$capacity конок',
      _ => 'до $capacity гостей',
    };
  }

  static String bookingPhone(Accommodation accommodation) {
    if (accommodation.bookingPhone != null &&
        accommodation.bookingPhone!.trim().isNotEmpty) {
      return accommodation.bookingPhone!;
    }
    return switch (accommodation.type) {
      AccommodationType.aFrame => AppConfig.aframeCottagesPhone,
      AccommodationType.barnhouse => AppConfig.hotelAlaArchaPhone,
      AccommodationType.hotelRoom => AppConfig.hotelAkBataPhone,
      AccommodationType.cabin => AppConfig.hotelAkmaralPhone,
      AccommodationType.dome => AppConfig.hotelAlaArchaPhone,
      AccommodationType.hut => AppConfig.hotelAkBataPhone,
    };
  }

  static IconData amenityIcon(String amenity) => switch (amenity) {
    'wifi' => Icons.wifi_rounded,
    'heating' => Icons.mode_night_rounded,
    'kitchen' => Icons.kitchen_rounded,
    'kitchenette' => Icons.flatware_rounded,
    'mountain_view' => Icons.landscape_rounded,
    'fireplace' => Icons.local_fire_department_rounded,
    'transparent_ceiling' => Icons.auto_awesome_rounded,
    'breakfast' => Icons.free_breakfast_rounded,
    'parking' => Icons.local_parking_rounded,
    'spa' => Icons.spa_rounded,
    'family' => Icons.family_restroom_rounded,
    _ => Icons.check_circle_outline_rounded,
  };

  static String amenityLabel(String amenity, String locale) {
    final labels = {
      'wifi': {'en': 'Wi-Fi', 'ru': 'Wi-Fi', 'ky': 'Wi-Fi'},
      'heating': {'en': 'Heating', 'ru': 'Отопление', 'ky': 'Жылытуу'},
      'kitchen': {'en': 'Kitchen', 'ru': 'Кухня', 'ky': 'Ашкана'},
      'kitchenette': {
        'en': 'Kitchenette',
        'ru': 'Мини-кухня',
        'ky': 'Мини ашкана',
      },
      'mountain_view': {
        'en': 'Mountain view',
        'ru': 'Вид на горы',
        'ky': 'Тоо көрүнүшү',
      },
      'fireplace': {'en': 'Fireplace', 'ru': 'Камин', 'ky': 'Камин'},
      'transparent_ceiling': {
        'en': 'Star view',
        'ru': 'Вид на звезды',
        'ky': 'Жылдыз көрүнүшү',
      },
      'breakfast': {
        'en': 'Breakfast',
        'ru': 'Завтрак',
        'ky': 'Эртең мененки тамак',
      },
      'parking': {'en': 'Parking', 'ru': 'Парковка', 'ky': 'Унаа токтотмо'},
      'spa': {'en': 'Spa', 'ru': 'Спа', 'ky': 'Спа'},
      'family': {
        'en': 'Family room',
        'ru': 'Семейный номер',
        'ky': 'Үй-бүлөлүк формат',
      },
    };
    final map = labels[amenity];
    return map?[locale] ?? map?['ru'] ?? amenity.replaceAll('_', ' ');
  }

  static String bookingMessage({
    required Accommodation accommodation,
    required int guests,
    DateTime? checkIn,
    DateTime? checkOut,
    String? note,
    String? customerName,
    required String locale,
  }) {
    final name = (customerName?.trim().isNotEmpty ?? false)
        ? customerName!.trim()
        : _fallbackGuestName(locale);
    final dates = checkIn != null && checkOut != null
        ? '${formatDate(checkIn, locale)} - ${formatDate(checkOut, locale)}'
        : _flexibleDatesLabel(locale);
    final extraNote = note?.trim().isNotEmpty == true
        ? '\n${_noteLabel(locale)}: ${note!.trim()}'
        : '';

    return switch (locale) {
      'en' =>
        'Hello! I want to book ${accommodation.name}.\n'
            'Guest: $name\n'
            'Dates: $dates\n'
            'Guests: $guests$extraNote',
      'ky' =>
        'Салам! ${accommodation.name} үчүн брондоо каалайм.\n'
            'Конок: $name\n'
            'Күндөр: $dates\n'
            'Коноктор: $guests$extraNote',
      _ =>
        'Здравствуйте! Хочу забронировать ${accommodation.name}.\n'
            'Гость: $name\n'
            'Даты: $dates\n'
            'Гостей: $guests$extraNote',
    };
  }

  static String formatDate(DateTime date, String locale) =>
      DateFormat('d MMM yyyy', locale).format(date);

  static String _formatNumber(int value) {
    final raw = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(raw[i]);
    }
    return buffer.toString();
  }

  static String _fallbackGuestName(String locale) =>
      {'en': 'Guest', 'ru': 'Гость', 'ky': 'Конок'}[locale] ?? 'Гость';

  static String _flexibleDatesLabel(String locale) =>
      {
        'en': 'Flexible, will confirm in chat',
        'ru': 'Гибкие, уточню в переписке',
        'ky': 'Тактайм, катта тактайм',
      }[locale] ??
      'Гибкие, уточню в переписке';

  static String _noteLabel(String locale) =>
      {'en': 'Note', 'ru': 'Комментарий', 'ky': 'Комментарий'}[locale] ??
      'Комментарий';
}
