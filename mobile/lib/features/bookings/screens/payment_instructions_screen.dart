import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/providers/booking_provider.dart';

class PaymentInstructionsScreen extends ConsumerWidget {
  const PaymentInstructionsScreen({super.key, required this.bookingId});

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
          // Total
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _amountLabel(locale),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.totalPriceKgs} KGS',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Step 1: reference
          _StepHeader(number: '1', title: _step1Label(locale)),
          const SizedBox(height: 12),
          _CopyCard(
            label: _refLabel(locale),
            value: booking.shortRef,
            highlight: true,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              _refHintLabel(locale),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Step 2: bank details
          _StepHeader(number: '2', title: _step2Label(locale)),
          const SizedBox(height: 12),
          _CopyCard(label: _bankLabel(locale), value: AppConfig.bankName),
          const SizedBox(height: 8),
          _CopyCard(label: _accountLabel(locale), value: AppConfig.bankAccount),
          const SizedBox(height: 8),
          _CopyCard(
              label: _recipientLabel(locale), value: AppConfig.bankRecipient),
          const SizedBox(height: 8),
          _CopyCard(label: 'БИК / BIK', value: AppConfig.bankBik),

          const SizedBox(height: 24),

          // Step 3: upload
          _StepHeader(number: '3', title: _step3Label(locale)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () =>
                  context.push('/bookings/$bookingId/receipt'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
              ),
              icon: const Icon(Icons.receipt_long),
              label: Text(
                _uploadCtaLabel(locale),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static String _titleLabel(String l) =>
      {'en': 'Payment', 'ru': 'Оплата', 'ky': 'Төлөм'}[l] ?? 'Оплата';
  static String _amountLabel(String l) =>
      {'en': 'AMOUNT DUE', 'ru': 'К ОПЛАТЕ', 'ky': 'ТӨЛӨНӨТ'}[l] ?? 'К ОПЛАТЕ';
  static String _step1Label(String l) =>
      {
        'en': 'Copy reference code',
        'ru': 'Скопируйте код брони',
        'ky': 'Бронь кодун көчүрүңүз',
      }[l] ??
      'Скопируйте код';
  static String _step2Label(String l) =>
      {
        'en': 'Transfer to bank account',
        'ru': 'Переведите на счёт',
        'ky': 'Эсепке которуңуз',
      }[l] ??
      'Переведите';
  static String _step3Label(String l) =>
      {
        'en': 'Upload the receipt',
        'ru': 'Загрузите чек',
        'ky': 'Чекти жүктөңүз',
      }[l] ??
      'Загрузите чек';
  static String _refLabel(String l) =>
      {'en': 'Reference', 'ru': 'Код брони', 'ky': 'Бронь коду'}[l] ??
      'Код брони';
  static String _bankLabel(String l) =>
      {'en': 'Bank', 'ru': 'Банк', 'ky': 'Банк'}[l] ?? 'Банк';
  static String _accountLabel(String l) =>
      {'en': 'Account', 'ru': 'Счёт', 'ky': 'Эсеп'}[l] ?? 'Счёт';
  static String _recipientLabel(String l) =>
      {'en': 'Recipient', 'ru': 'Получатель', 'ky': 'Алуучу'}[l] ?? 'Получатель';
  static String _refHintLabel(String l) =>
      {
        'en':
            'Paste this code into the transfer memo — it helps us match your payment automatically.',
        'ru':
            'Вставьте этот код в назначение платежа — по нему мы автоматически найдём ваш перевод.',
        'ky':
            'Бул кодду которуу эскертмесине жазыңыз — төлөмүңүздү тез табууга жардам берет.',
      }[l] ??
      '';
  static String _uploadCtaLabel(String l) =>
      {
        'en': "I've paid — upload receipt",
        'ru': 'Я оплатил — загрузить чек',
        'ky': 'Төлөдүм — чекти жүктөө',
      }[l] ??
      'Загрузить чек';
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.number, required this.title});
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _CopyCard extends StatelessWidget {
  const _CopyCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.secondary.withValues(alpha: 0.12)
            : AppColors.surface,
        border: Border.all(
          color: highlight ? AppColors.secondary : AppColors.border,
          width: highlight ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: highlight ? 20 : 15,
                    fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: highlight ? 1.5 : 0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: value));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 20),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
