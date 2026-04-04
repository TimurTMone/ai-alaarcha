import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  Future<void> _call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.emergency),
        backgroundColor: AppColors.sos,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            // SOS Button
            GestureDetector(
              onLongPress: () {
                // TODO: Send SOS alert with GPS
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.sosSent),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sos,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.sos.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              l.sosConfirm,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Emergency contacts
            _EmergencyContact(
              icon: Icons.forest,
              label: l.callRangers,
              number: '+996312123456',
              onTap: () => _call('+996312123456'),
            ),
            const SizedBox(height: 12),
            _EmergencyContact(
              icon: Icons.health_and_safety,
              label: l.callRescue,
              number: '+996312654321',
              onTap: () => _call('+996312654321'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _EmergencyContact extends StatelessWidget {
  final IconData icon;
  final String label;
  final String number;
  final VoidCallback onTap;

  const _EmergencyContact({
    required this.icon,
    required this.label,
    required this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.sos),
        label: Text(
          label,
          style: const TextStyle(color: AppColors.sos),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.sos),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
