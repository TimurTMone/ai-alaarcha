import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/pass_model.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/branded_qr_card.dart';
import '../../../core/constants/app_colors.dart';

class PassQRScreen extends StatelessWidget {
  final ParkPass pass;

  const PassQRScreen({super.key, required this.pass});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dateFormat = DateFormat('dd MMM yyyy');

    final typeLabel = switch (pass.type) {
      PassType.day => l.dayPass,
      PassType.multiDay => l.multiDayPass,
      PassType.annual => l.annualPass,
    };

    final categoryLabel = switch (pass.category) {
      PassCategory.citizen => l.citizen,
      PassCategory.tourist => l.tourist,
      PassCategory.child => l.child,
      PassCategory.student => l.student,
    };

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Text(
                typeLabel,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                categoryLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              BrandedQrCard(data: pass.qrCode, size: 240, padding: 24),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l.validUntil(dateFormat.format(pass.validTo)),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const Spacer(),
              Text(
                '${pass.price.toInt()} ${pass.currency}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.qr_code_scanner, color: Colors.white54, size: 18),
              const SizedBox(height: 4),
              Text(
                l.scanAtEntrance,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
