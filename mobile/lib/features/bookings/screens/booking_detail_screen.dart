import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/service_model.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/service_provider.dart';
import '../../../core/widgets/branded_qr_card.dart';

class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final booking = ref.watch(bookingByIdProvider(bookingId));

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_titleLabel(locale))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _statusBanner(booking, locale),
          const SizedBox(height: 24),
          _subjectCard(ref, booking, locale),
          const SizedBox(height: 16),
          _detailsCard(booking, locale),
          if (booking.aiVerification != null) ...[
            const SizedBox(height: 16),
            _aiVerificationCard(booking, locale),
          ],
          if (AppConfig.devMode &&
              booking.status == BookingStatus.pendingVerification) ...[
            const SizedBox(height: 24),
            _DevSimulateButtons(bookingId: bookingId),
          ],
        ],
      ),
    );
  }

  Widget _statusBanner(Booking b, String locale) {
    switch (b.status) {
      case BookingStatus.pendingPayment:
        return _banner(
          icon: Icons.payment,
          color: AppColors.warning,
          title: _titleStr(locale, 'Awaiting payment', 'Ожидает оплаты',
              'Төлөмдү күтүүдө'),
          body: _titleStr(
            locale,
            'Complete the bank transfer and upload your receipt.',
            'Сделайте перевод и загрузите чек.',
            'Которуу жасаңыз жана чекти жүктөңүз.',
          ),
        );
      case BookingStatus.pendingVerification:
        return _banner(
          icon: Icons.psychology,
          color: AppColors.info,
          title: _titleStr(
            locale,
            'AI is checking your receipt',
            'AI проверяет ваш чек',
            'AI чекти текшерүүдө',
          ),
          body: _titleStr(
            locale,
            'Usually takes a few seconds.',
            'Обычно занимает несколько секунд.',
            'Адатта бир нече секунд.',
          ),
          showSpinner: true,
        );
      case BookingStatus.needsReview:
        return _banner(
          icon: Icons.hourglass_top,
          color: AppColors.secondaryDark,
          title: _titleStr(
            locale,
            'Our team is reviewing',
            'Наша команда проверяет',
            'Командабыз текшерүүдө',
          ),
          body: _titleStr(
            locale,
            "We'll notify you as soon as your booking is approved.",
            'Мы уведомим вас, как только бронь будет подтверждена.',
            'Брон ырасталгандан кийин билдиребиз.',
          ),
        );
      case BookingStatus.approved:
      case BookingStatus.checkedIn:
        return _qrBlock(b, locale);
      case BookingStatus.rejected:
        return _banner(
          icon: Icons.cancel,
          color: AppColors.error,
          title: _titleStr(
            locale,
            'Booking rejected',
            'Бронь отклонена',
            'Брон четке кагылды',
          ),
          body: b.rejectionReason ??
              _titleStr(
                locale,
                'Please contact support.',
                'Свяжитесь со службой поддержки.',
                'Колдоо кызматына кайрылыңыз.',
              ),
        );
      case BookingStatus.completed:
        return _banner(
          icon: Icons.check_circle,
          color: AppColors.textSecondary,
          title: _titleStr(locale, 'Completed', 'Завершена', 'Бүткөн'),
          body: '',
        );
      case BookingStatus.cancelled:
        return _banner(
          icon: Icons.block,
          color: AppColors.textTertiary,
          title: _titleStr(locale, 'Cancelled', 'Отменена', 'Жокко чыгарылды'),
          body: '',
        );
    }
  }

  Widget _qrBlock(Booking b, String locale) {
    final qrData = b.qrCode ?? 'ALAARCHA-BOOKING-${b.id}';
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            _titleStr(locale, 'SHOW AT ENTRANCE', 'ПОКАЖИТЕ ПРИ ВХОДЕ',
                'КИРҮҮДӨ КӨРСӨТҮҢҮЗ'),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.85),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          BrandedQrCard(data: qrData, size: 220),
          const SizedBox(height: 12),
          Text(
            b.shortRef,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
    bool showSpinner = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showSpinner)
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: color,
              ),
            )
          else
            Icon(icon, color: color, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectCard(WidgetRef ref, Booking b, String locale) {
    String title = b.subjectId;
    String? subtitle;
    if (b.subjectType == BookingSubject.service) {
      final s = ref.watch(serviceByIdProvider(b.subjectId));
      if (s != null) {
        title = s.localizedName(locale);
        subtitle = s.venue;
      }
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null)
              Text(
                subtitle.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryDark,
                  letterSpacing: 0.6,
                ),
              ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsCard(Booking b, String locale) {
    final unitLabel = b.unit == null ? '' : _unitText(b.unit!, locale);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(_titleStr(locale, 'Reference', 'Код брони', 'Бронь коду'),
                b.shortRef, monospace: true),
            const Divider(height: 20),
            _row(_titleStr(locale, 'Quantity', 'Количество', 'Саны'),
                '${b.quantity} $unitLabel'.trim()),
            const Divider(height: 20),
            _row(
              _titleStr(locale, 'Total', 'Итого', 'Жыйынтыгы'),
              '${b.totalPriceKgs} KGS',
              bold: true,
            ),
            if (b.startsAt != null) ...[
              const Divider(height: 20),
              _row(
                _titleStr(locale, 'Date', 'Дата', 'Күн'),
                _formatDate(b.startsAt!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _aiVerificationCard(Booking b, String locale) {
    final v = b.aiVerification!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology_outlined,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  _titleStr(locale, 'AI verification', 'AI проверка',
                      'AI текшерүү'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(v.score * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            if (v.extractedAmountKgs != null) ...[
              const SizedBox(height: 8),
              Text(
                'Extracted: ${v.extractedAmountKgs} KGS',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
            if (v.notes != null) ...[
              const SizedBox(height: 4),
              Text(
                v.notes!,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value,
      {bool bold = false, bool monospace = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: bold ? AppColors.primary : AppColors.textPrimary,
            fontFamily: monospace ? 'monospace' : null,
          ),
        ),
      ],
    );
  }

  static String _titleLabel(String l) =>
      {'en': 'Booking', 'ru': 'Бронь', 'ky': 'Брон'}[l] ?? 'Бронь';

  static String _titleStr(String l, String en, String ru, String ky) =>
      l == 'en' ? en : (l == 'ky' ? ky : ru);

  static String _formatDate(DateTime d) =>
      '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  static String _unitText(PriceUnit u, String l) {
    const m = {
      PriceUnit.perNight: {'en': 'nights', 'ru': 'ночей', 'ky': 'түн'},
      PriceUnit.perHour: {'en': 'hours', 'ru': 'часов', 'ky': 'саат'},
      PriceUnit.perDay: {'en': 'days', 'ru': 'дней', 'ky': 'күн'},
      PriceUnit.perPerson: {'en': 'people', 'ru': 'чел.', 'ky': 'киши'},
      PriceUnit.perTable: {'en': 'tables', 'ru': 'столов', 'ky': 'үстөл'},
      PriceUnit.perItem: {'en': 'items', 'ru': 'шт.', 'ky': 'даана'},
      PriceUnit.flat: {'en': '', 'ru': '', 'ky': ''},
    };
    return m[u]?[l] ?? m[u]?['ru'] ?? '';
  }
}

/// Dev-only buttons to simulate the Cloud Function's decision locally.
class _DevSimulateButtons extends ConsumerWidget {
  const _DevSimulateButtons({required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void simulate({required bool approve}) {
      final booking = ref.read(bookingByIdProvider(bookingId));
      if (booking == null) return;
      final verification = AiVerification(
        score: approve ? 0.95 : 0.55,
        extractedAmountKgs:
            approve ? booking.totalPriceKgs : booking.totalPriceKgs - 200,
        extractedDate: DateTime.now(),
        extractedReference: approve ? booking.shortRef : 'unclear',
        notes: approve
            ? 'all checks passed'
            : 'amount mismatch; memo missing ref',
      );
      ref.read(devBookingsProvider.notifier).update(
            bookingId,
            (b) => b.copyWith(
              status: approve
                  ? BookingStatus.approved
                  : BookingStatus.needsReview,
              qrCode: approve
                  ? 'ALAARCHA.${bookingId.toUpperCase()}.DEVQR'
                  : null,
              aiVerification: verification,
            ),
          );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DEV MODE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.warning,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Simulate AI verification (real Cloud Function runs in prod)',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => simulate(approve: false),
                  icon: const Icon(Icons.flag_outlined, size: 18),
                  label: const Text('Flag'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => simulate(approve: true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
