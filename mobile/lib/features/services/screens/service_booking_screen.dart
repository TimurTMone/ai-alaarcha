import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/date_range.dart';
import '../../../core/mocks/mock_data.dart';
import '../../../core/models/service_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/service_provider.dart';

class ServiceBookingScreen extends ConsumerStatefulWidget {
  const ServiceBookingScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  ConsumerState<ServiceBookingScreen> createState() =>
      _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends ConsumerState<ServiceBookingScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int _quantity = 1;
  int _guests = 1;
  DateTime _calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);
  String _contactChannel = 'whatsapp';
  bool _seededUserFields = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required bool isStart,
    Set<DateTime>? blockedDates,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: isStart ? (_startDate ?? now) : (_endDate ?? now),
      selectableDayPredicate: blockedDates != null
          ? (day) {
              final normalized = DateTime(day.year, day.month, day.day);
              return !blockedDates.contains(normalized);
            }
          : null,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  int _computeQuantityForTotal(PriceUnit unit) {
    switch (unit) {
      case PriceUnit.perNight:
        if (_startDate != null && _endDate != null) {
          final nights = _endDate!.difference(_startDate!).inDays;
          return nights > 0 ? nights : 0;
        }
        return 0;
      case PriceUnit.perHour:
      case PriceUnit.perDay:
      case PriceUnit.perPerson:
      case PriceUnit.perTable:
      case PriceUnit.perItem:
        return _quantity;
      case PriceUnit.perVehicle:
      case PriceUnit.flat:
        return 1;
    }
  }

  bool _canSubmit(PriceUnit unit) {
    switch (unit) {
      case PriceUnit.perNight:
        return _computeQuantityForTotal(unit) > 0;
      case PriceUnit.perVehicle:
      case PriceUnit.flat:
        return true;
      default:
        return _startDate != null && _quantity > 0;
    }
  }

  /// Check if the selected date range overlaps with any existing booking.
  bool _hasConflict(List<DateRange> bookedRanges) {
    if (_startDate == null || _endDate == null) return false;
    for (final r in bookedRanges) {
      if (r.overlaps(_startDate!, _endDate!)) return true;
    }
    return false;
  }

  Future<void> _submit(Service service) async {
    if (_nameController.text.trim().isEmpty ||
        _contactController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _contactValidationLabel(
              Localizations.localeOf(context).languageCode,
            ),
          ),
        ),
      );
      return;
    }

    final checkIn = _startDate ?? DateTime.now();
    final checkOut = service.unit == PriceUnit.perNight
        ? (_endDate ?? checkIn)
        : (checkIn.add(const Duration(days: 1)));
    final qty = _computeQuantityForTotal(service.unit);
    final total = service.priceKgs * qty;
    setState(() => _isSubmitting = true);
    try {
      final booking = await ref
          .read(backendApiProvider)
          .createBooking(
            service: service,
            checkIn: checkIn,
            checkOut: checkOut,
            guests: _guests,
            quantity: qty > 0 ? qty : 1,
            customerName: _nameController.text.trim(),
            contactChannel: _contactChannel,
            contactValue: _contactController.text.trim(),
            note: _noteController.text,
            totalPriceKgs: total > 0 ? total : null,
          );

      ref
          .read(devBookingsProvider.notifier)
          .add(booking.copyWith(status: booking.status));

      if (!mounted) return;
      context.push('/bookings/${booking.id}/pay');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _submitErrorLabel(Localizations.localeOf(context).languageCode),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final service = ref.watch(serviceByIdProvider(widget.serviceId));
    final currentUser = ref.watch(currentUserProvider).valueOrNull;

    _seedFromUser(currentUser);

    if (service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Service not found')),
      );
    }

    // Load booked ranges for perNight services (hotels).
    final isHotel = service.unit == PriceUnit.perNight;
    final rangesAsync = isHotel
        ? ref.watch(bookedRangesProvider(service.id))
        : null;

    final bookedRanges = rangesAsync?.valueOrNull ?? const <DateRange>[];
    final blockedDates = <DateTime>{};
    for (final r in bookedRanges) {
      blockedDates.addAll(r.occupiedDates);
    }

    final conflict = isHotel && _hasConflict(bookedRanges);
    final qty = _computeQuantityForTotal(service.unit);
    final total = service.priceKgs * qty;

    return Scaffold(
      appBar: AppBar(title: Text(_bookTitle(locale))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Service summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (service.venue != null)
                    Text(
                      service.venue!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                  Text(
                    service.localizedName(locale),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${service.priceKgs} KGS ${_unitLabel(service.unit, locale)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Availability calendar for hotels ──
          if (isHotel) ...[
            Text(
              _availabilityTitle(locale),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            _AvailabilityLegend(locale: locale),
            const SizedBox(height: 8),
            _AvailabilityCalendar(
              month: _calendarMonth,
              blockedDates: blockedDates,
              selectedStart: _startDate,
              selectedEnd: _endDate,
              onPrevMonth: () => setState(() {
                _calendarMonth = DateTime(
                  _calendarMonth.year,
                  _calendarMonth.month - 1,
                );
              }),
              onNextMonth: () => setState(() {
                _calendarMonth = DateTime(
                  _calendarMonth.year,
                  _calendarMonth.month + 1,
                );
              }),
              onDayTap: (day) {
                setState(() {
                  if (_startDate == null || _endDate != null) {
                    _startDate = day;
                    _endDate = null;
                  } else {
                    if (day.isAfter(_startDate!)) {
                      _endDate = day;
                    } else {
                      _startDate = day;
                    }
                  }
                });
              },
              locale: locale,
            ),
            const SizedBox(height: 16),
          ],

          // Form fields
          ..._buildFormFields(service, locale, blockedDates),
          const SizedBox(height: 16),
          _contactSection(locale),

          if (conflict) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.block, color: AppColors.error, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _conflictLabel(locale),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  _totalLabel(locale),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '$total KGS',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _canSubmit(service.unit) && !conflict && !_isSubmitting
                  ? () => _submit(service)
                  : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _continueLabel(locale),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields(
    Service service,
    String locale,
    Set<DateTime> blockedDates,
  ) {
    switch (service.unit) {
      case PriceUnit.perNight:
        return [
          _dateTile(
            label: _checkInLabel(locale),
            date: _startDate,
            onTap: () => _pickDate(isStart: true, blockedDates: blockedDates),
          ),
          const SizedBox(height: 12),
          _dateTile(
            label: _checkOutLabel(locale),
            date: _endDate,
            onTap: () => _pickDate(isStart: false),
          ),
          const SizedBox(height: 16),
          _guestsStepper(locale),
        ];
      case PriceUnit.perVehicle:
      case PriceUnit.flat:
        return [
          Text(
            _flatConfirmLabel(locale),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ];
      default:
        return [
          _dateTile(
            label: _dateLabel(locale),
            date: _startDate,
            onTap: () => _pickDate(isStart: true),
          ),
          const SizedBox(height: 16),
          _quantityStepper(service.unit, locale),
          const SizedBox(height: 16),
          _guestsStepper(locale),
        ];
    }
  }

  Widget _contactSection(String locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _contactTitle(locale),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: _nameLabel(locale),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _contactChannel,
          decoration: InputDecoration(
            labelText: _channelLabel(locale),
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: 'whatsapp',
              child: Text(_whatsAppLabel(locale)),
            ),
            DropdownMenuItem(
              value: 'telegram',
              child: Text(_telegramLabel(locale)),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _contactChannel = value);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: _contactValueLabel(locale),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _noteController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: _noteLabel(locale),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Text(
              date == null
                  ? '—'
                  : '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityStepper(PriceUnit unit, String locale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            _quantityLabel(unit, locale),
            style: const TextStyle(fontSize: 14),
          ),
          const Spacer(),
          IconButton.outlined(
            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton.outlined(
            onPressed: () => setState(() => _quantity++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _guestsStepper(String locale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(_guestsLabel(locale), style: const TextStyle(fontSize: 14)),
          const Spacer(),
          IconButton.outlined(
            onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$_guests',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton.outlined(
            onPressed: () => setState(() => _guests++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _seedFromUser(AppUser? user) {
    if (_seededUserFields) return;
    final source = user ?? MockData.devUser;
    _nameController.text = source.displayName ?? '';
    _contactController.text = source.phone ?? source.email ?? '';
    _contactChannel = (source.phone?.isNotEmpty ?? false)
        ? 'whatsapp'
        : 'telegram';
    _seededUserFields = true;
  }

  // ── i18n labels ────────────────────────────────────────────────────

  static String _bookTitle(String l) =>
      {'en': 'Book', 'ru': 'Бронирование', 'ky': 'Брондоо'}[l] ??
      'Бронирование';
  static String _totalLabel(String l) =>
      {'en': 'Total', 'ru': 'Итого', 'ky': 'Жыйынтыгы'}[l] ?? 'Итого';
  static String _continueLabel(String l) =>
      {
        'en': 'Send booking request',
        'ru': 'Отправить заявку',
        'ky': 'Сурам жөнөтүү',
      }[l] ??
      'Отправить заявку';
  static String _checkInLabel(String l) =>
      {'en': 'Check-in', 'ru': 'Заезд', 'ky': 'Келүү'}[l] ?? 'Заезд';
  static String _checkOutLabel(String l) =>
      {'en': 'Check-out', 'ru': 'Выезд', 'ky': 'Кетүү'}[l] ?? 'Выезд';
  static String _dateLabel(String l) =>
      {'en': 'Date', 'ru': 'Дата', 'ky': 'Күн'}[l] ?? 'Дата';
  static String _flatConfirmLabel(String l) =>
      {
        'en': 'Fixed-price service. Send a request to confirm the booking.',
        'ru':
            'Услуга с фиксированной ценой. Отправьте заявку для подтверждения.',
        'ky': 'Белгиленген баалуу кызмат. Ырастоо үчүн сурам жөнөтүңүз.',
      }[l] ??
      'Услуга с фиксированной ценой.';
  static String _contactTitle(String l) =>
      {
        'en': 'Your contact details',
        'ru': 'Ваши контакты',
        'ky': 'Байланыш маалыматыңыз',
      }[l] ??
      'Ваши контакты';
  static String _nameLabel(String l) =>
      {'en': 'Name', 'ru': 'Имя', 'ky': 'Аты'}[l] ?? 'Имя';
  static String _channelLabel(String l) =>
      {
        'en': 'Preferred contact channel',
        'ru': 'Удобный канал связи',
        'ky': 'Байланыш каналы',
      }[l] ??
      'Удобный канал связи';
  static String _contactValueLabel(String l) =>
      {
        'en': 'Phone number or Telegram',
        'ru': 'Телефон или Telegram',
        'ky': 'Телефон же Telegram',
      }[l] ??
      'Телефон или Telegram';
  static String _noteLabel(String l) =>
      {'en': 'Comment', 'ru': 'Комментарий', 'ky': 'Комментарий'}[l] ??
      'Комментарий';
  static String _guestsLabel(String l) =>
      {'en': 'Guests', 'ru': 'Гостей', 'ky': 'Коноктор'}[l] ?? 'Гостей';
  static String _whatsAppLabel(String l) =>
      {'en': 'WhatsApp', 'ru': 'WhatsApp', 'ky': 'WhatsApp'}[l] ?? 'WhatsApp';
  static String _telegramLabel(String l) =>
      {'en': 'Telegram', 'ru': 'Telegram', 'ky': 'Telegram'}[l] ?? 'Telegram';
  static String _contactValidationLabel(String l) =>
      {
        'en': 'Enter your name and contact details before sending the request.',
        'ru': 'Укажите имя и контакт перед отправкой заявки.',
        'ky': 'Сурам жөнөтүүдөн мурун атыңызды жана контактыңызды жазыңыз.',
      }[l] ??
      'Укажите имя и контакт.';
  static String _submitErrorLabel(String l) =>
      {
        'en': 'Failed to send booking request. Please try again.',
        'ru': 'Не удалось отправить заявку. Попробуйте ещё раз.',
        'ky': 'Сурам жөнөтүлгөн жок. Кайра аракет кылыңыз.',
      }[l] ??
      'Не удалось отправить заявку.';
  static String _availabilityTitle(String l) =>
      {'en': 'Availability', 'ru': 'Доступность', 'ky': 'Жеткиликтүүлүк'}[l] ??
      'Доступность';
  static String _conflictLabel(String l) =>
      {
        'en': 'These dates are already booked. Please pick different dates.',
        'ru': 'Эти даты уже заняты. Выберите другие даты.',
        'ky': 'Бул даталар бронь кылынган. Башка даталарды тандаңыз.',
      }[l] ??
      'Эти даты заняты.';

  static String _quantityLabel(PriceUnit u, String l) {
    const m = {
      PriceUnit.perHour: {'en': 'Hours', 'ru': 'Часов', 'ky': 'Саат'},
      PriceUnit.perDay: {'en': 'Days', 'ru': 'Дней', 'ky': 'Күн'},
      PriceUnit.perPerson: {'en': 'People', 'ru': 'Человек', 'ky': 'Киши'},
      PriceUnit.perTable: {'en': 'Tables', 'ru': 'Столов', 'ky': 'Үстөл'},
      PriceUnit.perItem: {'en': 'Items', 'ru': 'Штук', 'ky': 'Даана'},
    };
    return m[u]?[l] ?? m[u]?['ru'] ?? 'Кол-во';
  }

  static String _unitLabel(PriceUnit u, String l) {
    const m = {
      PriceUnit.perNight: {'en': '/ night', 'ru': '/ ночь', 'ky': '/ түнгө'},
      PriceUnit.perHour: {'en': '/ hour', 'ru': '/ час', 'ky': '/ саат'},
      PriceUnit.perDay: {'en': '/ day', 'ru': '/ день', 'ky': '/ күн'},
      PriceUnit.perPerson: {'en': '/ person', 'ru': '/ чел.', 'ky': '/ киши'},
      PriceUnit.perTable: {'en': '/ table', 'ru': '/ стол', 'ky': '/ үстөл'},
      PriceUnit.perItem: {'en': '/ item', 'ru': '/ шт.', 'ky': '/ даана'},
      PriceUnit.perVehicle: {'en': '/ vehicle', 'ru': '/ авто', 'ky': '/ унаа'},
      PriceUnit.flat: {'en': '', 'ru': '', 'ky': ''},
    };
    return m[u]?[l] ?? m[u]?['ru'] ?? '';
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Availability calendar widget
// ═══════════════════════════════════════════════════════════════════════

class _AvailabilityLegend extends StatelessWidget {
  const _AvailabilityLegend({required this.locale});
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dot(AppColors.success),
        const SizedBox(width: 4),
        Text(_availableLabel, style: _style),
        const SizedBox(width: 16),
        _dot(AppColors.error),
        const SizedBox(width: 4),
        Text(_bookedLabel, style: _style),
        const SizedBox(width: 16),
        _dot(AppColors.primary),
        const SizedBox(width: 4),
        Text(_selectedLabel, style: _style),
      ],
    );
  }

  Widget _dot(Color c) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );

  static const _style = TextStyle(fontSize: 11, color: AppColors.textSecondary);

  String get _availableLabel =>
      {'en': 'Available', 'ru': 'Свободно', 'ky': 'Бош'}[locale] ?? 'Свободно';
  String get _bookedLabel =>
      {'en': 'Booked', 'ru': 'Занято', 'ky': 'Бронь'}[locale] ?? 'Занято';
  String get _selectedLabel =>
      {'en': 'Selected', 'ru': 'Выбрано', 'ky': 'Тандалды'}[locale] ??
      'Выбрано';
}

class _AvailabilityCalendar extends StatelessWidget {
  const _AvailabilityCalendar({
    required this.month,
    required this.blockedDates,
    required this.selectedStart,
    required this.selectedEnd,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDayTap,
    required this.locale,
  });

  final DateTime month;
  final Set<DateTime> blockedDates;
  final DateTime? selectedStart;
  final DateTime? selectedEnd;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final void Function(DateTime) onDayTap;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = firstDay.weekday; // 1=Mon, 7=Sun
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Month header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onPrevMonth,
                  icon: const Icon(Icons.chevron_left, size: 20),
                ),
                Text(
                  '${_monthName(month.month, locale)} ${month.year}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  onPressed: onNextMonth,
                  icon: const Icon(Icons.chevron_right, size: 20),
                ),
              ],
            ),
          ),
          // Day-of-week headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: _weekdayHeaders(locale)
                  .map(
                    (h) => Expanded(
                      child: Center(
                        child: Text(
                          h,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),
          // Day grid
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: ((startWeekday - 1) + daysInMonth + 6) ~/ 7 * 7,
              itemBuilder: (context, index) {
                final dayOffset = index - (startWeekday - 1);
                if (dayOffset < 0 || dayOffset >= daysInMonth) {
                  return const SizedBox.shrink();
                }
                final day = DateTime(month.year, month.month, dayOffset + 1);
                final isBlocked = blockedDates.contains(day);
                final isPast = day.isBefore(todayNorm);
                final isSelected = _isDaySelected(day);
                final isInRange = _isDayInRange(day);

                Color bgColor;
                Color textColor;
                if (isSelected) {
                  bgColor = AppColors.primary;
                  textColor = Colors.white;
                } else if (isInRange) {
                  bgColor = AppColors.primary.withValues(alpha: 0.15);
                  textColor = AppColors.primary;
                } else if (isBlocked) {
                  bgColor = AppColors.error.withValues(alpha: 0.12);
                  textColor = AppColors.error;
                } else if (isPast) {
                  bgColor = Colors.transparent;
                  textColor = AppColors.textTertiary;
                } else {
                  bgColor = AppColors.success.withValues(alpha: 0.08);
                  textColor = AppColors.textPrimary;
                }

                return GestureDetector(
                  onTap: (isBlocked || isPast) ? null : () => onDayTap(day),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${dayOffset + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: textColor,
                        decoration: isBlocked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isDaySelected(DateTime day) {
    if (selectedStart != null &&
        day.year == selectedStart!.year &&
        day.month == selectedStart!.month &&
        day.day == selectedStart!.day) {
      return true;
    }
    if (selectedEnd != null &&
        day.year == selectedEnd!.year &&
        day.month == selectedEnd!.month &&
        day.day == selectedEnd!.day) {
      return true;
    }
    return false;
  }

  bool _isDayInRange(DateTime day) {
    if (selectedStart == null || selectedEnd == null) return false;
    return day.isAfter(selectedStart!) && day.isBefore(selectedEnd!);
  }

  static String _monthName(int m, String l) {
    const ru = [
      '',
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    const en = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const ky = [
      '',
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    if (l == 'en') return en[m];
    if (l == 'ky') return ky[m];
    return ru[m];
  }

  static List<String> _weekdayHeaders(String l) {
    if (l == 'en') return ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    if (l == 'ky') return ['Дш', 'Шш', 'Шр', 'Бш', 'Жм', 'Иш', 'Жк'];
    return ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  }
}
