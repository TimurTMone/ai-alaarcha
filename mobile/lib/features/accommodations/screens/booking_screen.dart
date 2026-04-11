import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/models/accommodation_model.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/utils/l10n_extension.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Accommodation accommodation;

  const BookingScreen({super.key, required this.accommodation});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 2;
  bool _isSubmitting = false;

  int get _nights => (_checkIn != null && _checkOut != null)
      ? _checkOut!.difference(_checkIn!).inDays
      : 0;

  double get _totalPrice => _nights * widget.accommodation.pricePerNight;

  bool get _canConfirm =>
      _nights > 0 && _guests > 0 && _guests <= widget.accommodation.capacity;

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

  Future<void> _confirm() async {
    if (!_canConfirm) return;

    setState(() => _isSubmitting = true);
    try {
      final now = DateTime.now();
      final bookingId = 'stay-${now.microsecondsSinceEpoch}';
      final userId =
          ref.read(currentUserProvider).valueOrNull?.uid ?? 'dev-user';
      final booking = Booking(
        id: bookingId,
        userId: userId,
        code: _shortCode(bookingId),
        subjectTitle: widget.accommodation.name,
        subjectType: BookingSubject.accommodation,
        subjectId: widget.accommodation.id,
        quantity: _nights,
        startsAt: _checkIn!,
        endsAt: _checkOut!,
        guests: _guests,
        totalPriceKgs: _totalPrice.round(),
        currency: widget.accommodation.currency,
        status: BookingStatus.pendingPayment,
        createdAt: now,
      );

      if (AppConfig.devMode || AppConfig.useBackendBookings) {
        ref.read(devBookingsProvider.notifier).add(booking);
      } else {
        await ref.read(firestoreServiceProvider).createBooking(booking);
      }

      if (!mounted) return;
      context.pushReplacement('/bookings/${booking.id}/pay');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _shortCode(String id) => id.length <= 6
      ? id.toUpperCase()
      : id.substring(id.length - 6).toUpperCase();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dateFormat = DateFormat('dd MMM');

    return Scaffold(
      appBar: AppBar(title: Text(widget.accommodation.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionLabel(label: l.selectDates),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDates,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _checkIn != null && _checkOut != null
                          ? '${dateFormat.format(_checkIn!)} — ${dateFormat.format(_checkOut!)}'
                          : l.selectDates,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _checkIn != null
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: l.guests),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$_guests',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _guests > 1
                      ? () => setState(() => _guests--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                IconButton(
                  onPressed: _guests < widget.accommodation.capacity
                      ? () => setState(() => _guests++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.maxCapacity(widget.accommodation.capacity),
            style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 24),
          if (_nights > 0) ...[
            _SectionLabel(label: l.total),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label:
                        '\$${widget.accommodation.pricePerNight.toInt()} × ${l.nightCount(_nights)}',
                    value: '\$${_totalPrice.toInt()}',
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: l.total,
                    value: '\$${_totalPrice.toInt()}',
                    bold: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _canConfirm && !_isSubmitting ? _confirm : null,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l.confirmBooking),
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
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
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
    final style = TextStyle(
      fontSize: bold ? 16 : 14,
      fontWeight: bold ? FontWeight.bold : FontWeight.w500,
      color: bold ? AppColors.textPrimary : AppColors.textSecondary,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
