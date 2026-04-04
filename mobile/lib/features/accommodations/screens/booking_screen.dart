import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/accommodation_model.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/branded_qr_card.dart';

class BookingScreen extends StatefulWidget {
  final Accommodation accommodation;

  const BookingScreen({super.key, required this.accommodation});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 2;

  int get _nights =>
      (_checkIn != null && _checkOut != null)
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

  void _confirm() {
    final qrData =
        'ALAARCHA-BOOKING-${widget.accommodation.id}-${DateTime.now().millisecondsSinceEpoch}';
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => _ConfirmationScreen(
          accommodation: widget.accommodation,
          checkIn: _checkIn!,
          checkOut: _checkOut!,
          guests: _guests,
          totalPrice: _totalPrice,
          qrData: qrData,
        ),
      ),
    );
  }

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
                  onPressed:
                      _guests > 1 ? () => setState(() => _guests--) : null,
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
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
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
            onPressed: _canConfirm ? _confirm : null,
            child: Text(l.confirmBooking),
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

class _ConfirmationScreen extends StatelessWidget {
  final Accommodation accommodation;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String qrData;

  const _ConfirmationScreen({
    required this.accommodation,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dateFormat = DateFormat('EEE, dd MMM');

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),
              Text(
                l.bookingConfirmed,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                accommodation.name,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              BrandedQrCard(data: qrData, size: 180),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      label: l.checkIn,
                      value: dateFormat.format(checkIn),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: l.checkOut,
                      value: dateFormat.format(checkOut),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(label: l.guests, value: '$guests'),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: l.total,
                      value: '\$${totalPrice.toInt()}',
                      bold: true,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                  ),
                  child: Text(l.done),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: bold ? 18 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
