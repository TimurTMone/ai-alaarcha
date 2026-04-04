import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/trail_model.dart';
import '../../../core/providers/trail_provider.dart';
import '../../../core/utils/l10n_extension.dart';

class TrailsMapScreen extends ConsumerWidget {
  const TrailsMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final trails = ref.watch(trailsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.trails)),
      body: trails.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final trail = items[i];
            return _TrailCard(
              trail: trail,
              onTap: () => context.push('/trails/${trail.id}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.error)),
      ),
    );
  }
}

class _TrailCard extends StatelessWidget {
  final Trail trail;
  final VoidCallback onTap;

  const _TrailCard({required this.trail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    final statusLabel = switch (trail.status) {
      TrailStatus.open => l.trailOpen,
      TrailStatus.caution => l.trailCaution,
      TrailStatus.closed => l.trailClosed,
    };

    final statusColor = switch (trail.status) {
      TrailStatus.open => AppColors.success,
      TrailStatus.caution => AppColors.warning,
      TrailStatus.closed => AppColors.error,
    };

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trail.localizedName('ru'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
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
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.terrain,
                    label: trail.difficulty,
                  ),
                  const SizedBox(width: 16),
                  _InfoChip(
                    icon: Icons.straighten,
                    label: '${trail.distance} km',
                  ),
                  const SizedBox(width: 16),
                  _InfoChip(
                    icon: Icons.trending_up,
                    label: '${trail.elevationGain}m',
                  ),
                  const SizedBox(width: 16),
                  _InfoChip(
                    icon: Icons.schedule,
                    label: trail.estimatedTimeFormatted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
