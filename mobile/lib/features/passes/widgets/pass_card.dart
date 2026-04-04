import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/pass_model.dart';
import '../../../core/utils/l10n_extension.dart';
import '../screens/pass_qr_screen.dart';

class PassCard extends StatelessWidget {
  final ParkPass pass;

  const PassCard({super.key, required this.pass});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dateFormat = DateFormat('dd MMM yyyy');

    final statusLabel = switch (pass.status) {
      PassStatus.active => l.passActive,
      PassStatus.used => l.passUsed,
      PassStatus.expired => l.passExpired,
      PassStatus.refunded => l.cancelled,
    };

    final statusColor = switch (pass.status) {
      PassStatus.active => AppColors.success,
      PassStatus.used => AppColors.info,
      PassStatus.expired => AppColors.textTertiary,
      PassStatus.refunded => AppColors.error,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${pass.price.toInt()} ${pass.currency}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l.validUntil(dateFormat.format(pass.validTo)),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            if (pass.isValid) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PassQRScreen(pass: pass),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code_2),
                  label: Text(l.showQR),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
