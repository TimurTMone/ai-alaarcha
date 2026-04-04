import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onBuyPass;
  final VoidCallback onMyPasses;
  final VoidCallback onGondola;
  final VoidCallback onTours;

  const QuickActions({
    super.key,
    required this.onBuyPass,
    required this.onMyPasses,
    required this.onGondola,
    required this.onTours,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Row(
      children: [
        _ActionItem(
          icon: Icons.qr_code_2,
          label: l.buyPass,
          color: AppColors.primary,
          onTap: onBuyPass,
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.confirmation_num,
          label: l.myPasses,
          color: AppColors.accent,
          onTap: onMyPasses,
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.tram,
          label: l.gondola,
          color: AppColors.secondary,
          onTap: onGondola,
        ),
        const SizedBox(width: 12),
        _ActionItem(
          icon: Icons.hiking,
          label: l.tours,
          color: AppColors.success,
          onTap: onTours,
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
