import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onBuyPass;
  final VoidCallback onMyPasses;
  final VoidCallback onStays;

  const QuickActions({
    super.key,
    required this.onBuyPass,
    required this.onMyPasses,
    required this.onStays,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _titleLabel(locale),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _subtitleLabel(locale),
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;
            return GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isCompact ? 2 : 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: isCompact ? 154 : 168,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _ActionItem(
                  icon: Icons.qr_code_2_rounded,
                  label: l.buyPass,
                  subtitle: _buyPassLabel(locale),
                  color: AppColors.primary,
                  onTap: onBuyPass,
                ),
                _ActionItem(
                  icon: Icons.confirmation_num_rounded,
                  label: l.myPasses,
                  subtitle: _myPassesLabel(locale),
                  color: AppColors.accent,
                  onTap: onMyPasses,
                ),
                _ActionItem(
                  icon: Icons.hotel_rounded,
                  label: _staysLabel(locale),
                  subtitle: _staysSubtitle(locale),
                  color: AppColors.secondaryDark,
                  onTap: onStays,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  static String _titleLabel(String locale) =>
      {
        'en': 'Quick actions',
        'ru': 'Быстрые действия',
        'ky': 'Тез аракеттер',
      }[locale] ??
      'Быстрые действия';

  static String _subtitleLabel(String locale) =>
      {
        'en': 'The most useful things are one tap away.',
        'ru': 'Самое нужное под рукой в один тап.',
        'ky': 'Эң керектүү нерселер бир тапта.',
      }[locale] ??
      'Самое нужное под рукой в один тап.';

  static String _buyPassLabel(String locale) =>
      {'en': 'Entrance', 'ru': 'Вход в парк', 'ky': 'Паркка кирүү'}[locale] ??
      'Вход в парк';

  static String _myPassesLabel(String locale) =>
      {
        'en': 'QR and validity',
        'ru': 'QR и срок действия',
        'ky': 'QR жана мөөнөтү',
      }[locale] ??
      'QR и срок действия';

  static String _staysLabel(String locale) =>
      {'en': 'Stays', 'ru': 'Проживание', 'ky': 'Жашоо жайы'}[locale] ??
      'Проживание';

  static String _staysSubtitle(String locale) =>
      {
        'en': 'Hotels and cabins',
        'ru': 'Отели и домики',
        'ky': 'Мейманкана жана үйлөр',
      }[locale] ??
      'Отели и домики';
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
