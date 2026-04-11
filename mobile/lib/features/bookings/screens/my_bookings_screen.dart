import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/service_provider.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final bookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                _titleLabel(locale),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: bookingsAsync.when(
                data: (bookings) {
                  if (bookings.isEmpty) {
                    return _EmptyState(locale: locale);
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: bookings.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => _BookingCard(
                      booking: bookings[i],
                      locale: locale,
                    ),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _titleLabel(String l) =>
      {'en': 'My Bookings', 'ru': 'Мои брони', 'ky': 'Менин брондорум'}[l] ??
      'Мои брони';
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.locale});
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_note,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _noBookingsLabel(locale),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _hintLabel(locale),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.explore),
            label: Text(_browseLabel(locale)),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  static String _noBookingsLabel(String l) =>
      {
        'en': 'No bookings yet',
        'ru': 'Пока нет броней',
        'ky': 'Азырынча брон жок',
      }[l] ??
      'Пока нет броней';
  static String _hintLabel(String l) =>
      {
        'en': 'Browse services on the home screen to make your first booking.',
        'ru': 'Выберите услугу на главной, чтобы создать первую бронь.',
        'ky': 'Башкы бетте кызматты тандап, биринчи бронду жасаңыз.',
      }[l] ??
      '';
  static String _browseLabel(String l) =>
      {'en': 'Browse services', 'ru': 'К услугам', 'ky': 'Кызматтарга'}[l] ??
      'К услугам';
}

class _BookingCard extends ConsumerWidget {
  const _BookingCard({required this.booking, required this.locale});

  final Booking booking;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectTitle = _subjectTitle(ref);
    final status = _StatusChip(status: booking.status, locale: locale);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/bookings/${booking.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      subjectTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  status,
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${_refLabel(locale)} ${booking.shortRef}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: AppColors.textTertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatDate(booking.createdAt, locale),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${booking.totalPriceKgs} KGS',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subjectTitle(WidgetRef ref) {
    if (booking.subjectTitle?.isNotEmpty == true) {
      return booking.subjectTitle!;
    }
    if (booking.subjectType == BookingSubject.service) {
      final service = ref.watch(serviceByIdProvider(booking.subjectId));
      return service?.localizedName(locale) ?? booking.subjectId;
    }
    return booking.subjectId;
  }

  static String _refLabel(String l) =>
      {'en': 'Ref', 'ru': 'Код', 'ky': 'Код'}[l] ?? 'Код';

  static String _formatDate(DateTime d, String locale) {
    return '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.locale});
  final BookingStatus status;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = _styling(status, locale);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  static (Color, Color, String) _styling(BookingStatus s, String l) {
    switch (s) {
      case BookingStatus.pendingPayment:
        return (
          AppColors.warning.withValues(alpha: 0.15),
          AppColors.warning,
          _label(
            l,
            'REQUEST',
            'ЗАЯВКА',
            'СУРАМ',
          ),
        );
      case BookingStatus.pendingVerification:
        return (
          AppColors.info.withValues(alpha: 0.15),
          AppColors.info,
          _label(l, 'CHECKING', 'ПРОВЕРКА', 'ТЕКШЕРҮҮ'),
        );
      case BookingStatus.needsReview:
        return (
          AppColors.secondary.withValues(alpha: 0.2),
          AppColors.secondaryDark,
          _label(l, 'REVIEW', 'ПРОВЕРКА', 'КАРАЛУУДА'),
        );
      case BookingStatus.approved:
        return (
          AppColors.success.withValues(alpha: 0.15),
          AppColors.success,
          _label(l, 'APPROVED', 'ПОДТВЕРЖДЕНО', 'ЫРАСТАЛДЫ'),
        );
      case BookingStatus.rejected:
        return (
          AppColors.error.withValues(alpha: 0.15),
          AppColors.error,
          _label(l, 'REJECTED', 'ОТКЛОНЕНО', 'ЧЕТКЕ КАКТЫ'),
        );
      case BookingStatus.checkedIn:
        return (
          AppColors.primary.withValues(alpha: 0.15),
          AppColors.primary,
          _label(l, 'ACTIVE', 'АКТИВНА', 'АКТИВДҮҮ'),
        );
      case BookingStatus.completed:
        return (
          AppColors.textTertiary.withValues(alpha: 0.15),
          AppColors.textSecondary,
          _label(l, 'DONE', 'ЗАВЕРШЕНА', 'БҮТКӨН'),
        );
      case BookingStatus.cancelled:
        return (
          AppColors.textTertiary.withValues(alpha: 0.15),
          AppColors.textTertiary,
          _label(l, 'CANCELLED', 'ОТМЕНЕНА', 'ЖОККО ЧЫГАРЫЛДЫ'),
        );
    }
  }

  static String _label(String l, String en, String ru, String ky) =>
      l == 'en' ? en : (l == 'ky' ? ky : ru);
}
