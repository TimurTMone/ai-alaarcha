import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/accommodation_model.dart';
import '../../../core/providers/accommodation_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/contact_launcher.dart';
import '../widgets/accommodation_image_backdrop.dart';
import '../widgets/accommodation_presentation.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String accommodationId;

  const BookingScreen({super.key, required this.accommodationId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 2;
  final TextEditingController _noteController = TextEditingController();
  bool _isOpeningWhatsApp = false;

  int get _nights => (_checkIn != null && _checkOut != null)
      ? _checkOut!.difference(_checkIn!).inDays
      : 0;

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _checkIn != null && _checkOut != null
          ? DateTimeRange(start: _checkIn!, end: _checkOut!)
          : null,
    );

    if (range != null) {
      setState(() {
        _checkIn = range.start;
        _checkOut = range.end;
      });
    }
  }

  Future<void> _openWhatsApp(Accommodation accommodation) async {
    if (_guests > accommodation.capacity) return;

    final locale = Localizations.localeOf(context).languageCode;
    final user = ref.read(currentUserProvider).valueOrNull;
    final message = AccommodationPresentation.bookingMessage(
      accommodation: accommodation,
      guests: _guests,
      checkIn: _checkIn,
      checkOut: _checkOut,
      note: _noteController.text,
      customerName: user?.displayName ?? user?.email ?? user?.phone,
      locale: locale,
    );

    setState(() => _isOpeningWhatsApp = true);
    await ContactLauncher.openWhatsApp(
      context: context,
      phoneNumber: AccommodationPresentation.bookingPhone(accommodation),
      message: message,
    );
    if (mounted) {
      setState(() => _isOpeningWhatsApp = false);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('d MMM', locale);
    final accommodation = ref.watch(
      accommodationProvider(widget.accommodationId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(_pageTitle(locale))),
      body: accommodation.when(
        data: (item) {
          if (item == null) {
            return Center(child: Text(_notFoundLabel(locale)));
          }

          final summaryTotal = _nights > 0
              ? AccommodationPresentation.formatAmount(
                  item.pricePerNight * _nights,
                  item.currency,
                )
              : null;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
            children: [
              _BookingHero(accommodation: item, locale: locale),
              const SizedBox(height: 20),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: _datesLabel(locale)),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _pickDates,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.calendar_month_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _checkIn != null && _checkOut != null
                                    ? '${dateFormat.format(_checkIn!)} - ${dateFormat.format(_checkOut!)}'
                                    : _datesPlaceholder(locale),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _checkIn != null
                                      ? AppColors.textPrimary
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionLabel(label: _guestsLabel(locale)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.people_alt_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _guestCountLabel(locale, _guests),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _guests > 1
                                ? () => setState(() => _guests--)
                                : null,
                            icon: const Icon(
                              Icons.remove_circle_outline_rounded,
                            ),
                          ),
                          IconButton(
                            onPressed: _guests < item.capacity
                                ? () => setState(() => _guests++)
                                : null,
                            icon: const Icon(Icons.add_circle_outline_rounded),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _maxGuestsLabel(locale, item.capacity),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: _noteFieldLabel(locale)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: _notePlaceholder(locale),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFF25D366),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _whatsAppInfo(locale),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: _summaryLabel(locale)),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      label: _pricePerNightLabel(locale),
                      value:
                          '${AccommodationPresentation.priceLabel(item)} · ${AccommodationPresentation.perNightLabel(locale)}',
                    ),
                    _SummaryRow(
                      label: _datesSummaryLabel(locale),
                      value: _checkIn != null && _checkOut != null
                          ? '${dateFormat.format(_checkIn!)} - ${dateFormat.format(_checkOut!)}'
                          : _flexibleLabel(locale),
                    ),
                    _SummaryRow(
                      label: _contactLabel(locale),
                      value: AccommodationPresentation.bookingPhone(item),
                    ),
                    if (summaryTotal != null) ...[
                      const Divider(height: 28),
                      _SummaryRow(
                        label: _totalLabel(locale),
                        value: summaryTotal,
                        bold: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(_errorLabel(locale))),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: FilledButton.icon(
            onPressed: _isOpeningWhatsApp
                ? null
                : () {
                    final item = accommodation.valueOrNull;
                    if (item == null) return;
                    _openWhatsApp(item);
                  },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
            icon: _isOpeningWhatsApp
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_rounded, size: 16),
                  ),
            label: Text(_buttonLabel(locale)),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: bold ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _BookingHero extends StatelessWidget {
  const _BookingHero({required this.accommodation, required this.locale});

  final Accommodation accommodation;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 220,
        child: AccommodationImageBackdrop(
          accommodation: accommodation,
          showPlaceholderIcon: false,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    AccommodationPresentation.typeLabel(
                      accommodation.type,
                      locale,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  accommodation.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AccommodationPresentation.priceLabel(accommodation),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _heroSubtitle(locale),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _heroSubtitle(String locale) =>
      {
        'en': 'Choose dates and open a ready-made request in WhatsApp.',
        'ru': 'Выберите даты и откройте готовую заявку в WhatsApp.',
        'ky': 'Күндөрдү тандап, WhatsApp ичинде даяр арызды ачыңыз.',
      }[locale] ??
      'Выберите даты и откройте готовую заявку в WhatsApp.';
}

String _pageTitle(String locale) =>
    {
      'en': 'Booking request',
      'ru': 'Заявка на бронирование',
      'ky': 'Брондоо арызы',
    }[locale] ??
    'Заявка на бронирование';

String _notFoundLabel(String locale) =>
    {
      'en': 'Accommodation not found',
      'ru': 'Проживание не найдено',
      'ky': 'Жашоо жайы табылган жок',
    }[locale] ??
    'Проживание не найдено';

String _datesLabel(String locale) =>
    {'en': 'Dates', 'ru': 'Даты', 'ky': 'Күндөр'}[locale] ?? 'Даты';

String _datesPlaceholder(String locale) =>
    {
      'en': 'Select dates or leave flexible',
      'ru': 'Выберите даты или оставьте гибкими',
      'ky': 'Күндөрдү тандаңыз же бош калтырыңыз',
    }[locale] ??
    'Выберите даты или оставьте гибкими';

String _guestsLabel(String locale) =>
    {'en': 'Guests', 'ru': 'Гости', 'ky': 'Коноктор'}[locale] ?? 'Гости';

String _guestCountLabel(String locale, int guests) => switch (locale) {
  'en' => '$guests guests',
  'ky' => '$guests конок',
  _ => '$guests гостей',
};

String _maxGuestsLabel(String locale, int capacity) => switch (locale) {
  'en' => 'Up to $capacity guests',
  'ky' => 'Эң көбү $capacity конок',
  _ => 'Максимум $capacity гостей',
};

String _noteFieldLabel(String locale) =>
    {'en': 'Comment', 'ru': 'Комментарий', 'ky': 'Комментарий'}[locale] ??
    'Комментарий';

String _notePlaceholder(String locale) =>
    {
      'en': 'Write a request, arrival time, or any wishes.',
      'ru': 'Напишите пожелания, время заезда или важные детали.',
      'ky':
          'Каалоолоруңузду, келүү убактыңызды же маанилүү деталдарды жазыңыз.',
    }[locale] ??
    'Напишите пожелания, время заезда или важные детали.';

String _whatsAppInfo(String locale) =>
    {
      'en':
          'After tapping the button, WhatsApp will open with a ready-made message to the accommodation manager.',
      'ru':
          'После нажатия откроется WhatsApp с готовым сообщением для менеджера проживания.',
      'ky':
          'Баскычты баскандан кийин жашоо жайынын менеджерине даяр билдирүү менен WhatsApp ачылат.',
    }[locale] ??
    'После нажатия откроется WhatsApp с готовым сообщением для менеджера проживания.';

String _summaryLabel(String locale) =>
    {
      'en': 'Booking summary',
      'ru': 'Сводка бронирования',
      'ky': 'Брондоо жыйынтыгы',
    }[locale] ??
    'Сводка бронирования';

String _pricePerNightLabel(String locale) =>
    {'en': 'Rate', 'ru': 'Тариф', 'ky': 'Тариф'}[locale] ?? 'Тариф';

String _datesSummaryLabel(String locale) =>
    {'en': 'Dates', 'ru': 'Даты', 'ky': 'Күндөр'}[locale] ?? 'Даты';

String _contactLabel(String locale) =>
    {'en': 'WhatsApp', 'ru': 'WhatsApp', 'ky': 'WhatsApp'}[locale] ??
    'WhatsApp';

String _flexibleLabel(String locale) =>
    {'en': 'Flexible', 'ru': 'Гибкие', 'ky': 'Эркин'}[locale] ?? 'Гибкие';

String _totalLabel(String locale) =>
    {'en': 'Total', 'ru': 'Итого', 'ky': 'Жалпы'}[locale] ?? 'Итого';

String _buttonLabel(String locale) =>
    {
      'en': 'Book in WhatsApp',
      'ru': 'Забронировать в WhatsApp',
      'ky': 'WhatsApp менен брондоо',
    }[locale] ??
    'Забронировать в WhatsApp';

String _errorLabel(String locale) =>
    {
      'en': 'Could not load accommodation',
      'ru': 'Не удалось загрузить проживание',
      'ky': 'Жашоо жайын жүктөө мүмкүн болгон жок',
    }[locale] ??
    'Не удалось загрузить проживание';
