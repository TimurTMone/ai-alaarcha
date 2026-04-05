import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/mocks/mock_data.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/service_model.dart';
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
  DateTime? _startDate;
  DateTime? _endDate;
  int _quantity = 1;

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: isStart ? (_startDate ?? now) : (_endDate ?? now),
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
      case PriceUnit.flat:
        return 1;
    }
  }

  bool _canSubmit(PriceUnit unit) {
    switch (unit) {
      case PriceUnit.perNight:
        return _computeQuantityForTotal(unit) > 0;
      case PriceUnit.flat:
        return true;
      default:
        return _startDate != null && _quantity > 0;
    }
  }

  void _submit(Service service) {
    final qty = _computeQuantityForTotal(service.unit);
    final total = service.priceKgs * qty;
    final now = DateTime.now();
    final id = 'bk-${now.millisecondsSinceEpoch.toRadixString(36)}';

    final booking = Booking(
      id: id,
      userId: MockData.devUserId,
      subjectType: BookingSubject.service,
      subjectId: service.id,
      unit: service.unit,
      quantity: qty,
      startsAt: _startDate,
      endsAt: service.unit == PriceUnit.perNight ? _endDate : null,
      totalPriceKgs: total,
      status: BookingStatus.pendingPayment,
      createdAt: now,
    );

    ref.read(devBookingsProvider.notifier).add(booking);
    context.push('/bookings/$id/pay');
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final service = ref.watch(serviceByIdProvider(widget.serviceId));

    if (service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Service not found')),
      );
    }

    final qty = _computeQuantityForTotal(service.unit);
    final total = service.priceKgs * qty;

    return Scaffold(
      appBar: AppBar(title: Text(_bookTitle(locale))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Service summary
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

          // Form adapts to unit
          ..._buildFormFields(service, locale),

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
              onPressed: _canSubmit(service.unit) ? () => _submit(service) : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                _continueLabel(locale),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields(Service service, String locale) {
    switch (service.unit) {
      case PriceUnit.perNight:
        return [
          _dateTile(
            label: _checkInLabel(locale),
            date: _startDate,
            onTap: () => _pickDate(isStart: true),
          ),
          const SizedBox(height: 12),
          _dateTile(
            label: _checkOutLabel(locale),
            date: _endDate,
            onTap: () => _pickDate(isStart: false),
          ),
        ];
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
        ];
    }
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
            const Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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

  static String _bookTitle(String l) =>
      {'en': 'Book', 'ru': 'Бронирование', 'ky': 'Брондоо'}[l] ?? 'Бронирование';
  static String _totalLabel(String l) =>
      {'en': 'Total', 'ru': 'Итого', 'ky': 'Жыйынтыгы'}[l] ?? 'Итого';
  static String _continueLabel(String l) =>
      {'en': 'Continue to payment', 'ru': 'К оплате', 'ky': 'Төлөмгө'}[l] ??
      'К оплате';
  static String _checkInLabel(String l) =>
      {'en': 'Check-in', 'ru': 'Заезд', 'ky': 'Келүү'}[l] ?? 'Заезд';
  static String _checkOutLabel(String l) =>
      {'en': 'Check-out', 'ru': 'Выезд', 'ky': 'Кетүү'}[l] ?? 'Выезд';
  static String _dateLabel(String l) =>
      {'en': 'Date', 'ru': 'Дата', 'ky': 'Күн'}[l] ?? 'Дата';
  static String _flatConfirmLabel(String l) =>
      {
        'en': 'Fixed-price service. Continue to payment to book.',
        'ru': 'Услуга с фиксированной ценой. Перейдите к оплате.',
        'ky': 'Белгиленген баалуу кызмат. Төлөмгө өтүңүз.',
      }[l] ??
      'Услуга с фиксированной ценой.';

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
      PriceUnit.flat: {'en': '', 'ru': '', 'ky': ''},
    };
    return m[u]?[l] ?? m[u]?['ru'] ?? '';
  }
}
