import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/trail_model.dart';
import '../../../core/providers/trail_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../widgets/trail_map_widget.dart';

class TrailDetailScreen extends ConsumerWidget {
  final String trailId;

  const TrailDetailScreen({super.key, required this.trailId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final trail = ref.watch(trailProvider(trailId));
    final trailItem = trail.valueOrNull;

    return Scaffold(
      body: trail.when(
        data: (item) {
          if (item == null) return Center(child: Text(l.noResults));
          final locale = Localizations.localeOf(context).languageCode;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    item.localizedName(locale),
                    style: const TextStyle(fontSize: 16),
                  ),
                  background: Container(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: const Center(
                      child: Icon(
                        Icons.map,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatCard(
                            label: l.difficulty,
                            value: item.difficulty,
                            icon: Icons.terrain,
                          ),
                          _StatCard(
                            label: l.distance,
                            value: '${item.distance} km',
                            icon: Icons.straighten,
                          ),
                          _StatCard(
                            label: l.elevation,
                            value: '${item.elevationGain}m',
                            icon: Icons.trending_up,
                          ),
                          _StatCard(
                            label: l.estimatedTime,
                            value: item.estimatedTimeFormatted,
                            icon: Icons.schedule,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        item.localizedDescription(locale),
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: TrailMapWidget(
                          trails: [item],
                          compact: true,
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.error)),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: Text(l.downloadOffline),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: trailItem == null
                      ? null
                      : () => _openNavigation(trailItem),
                  icon: const Icon(Icons.navigation),
                  label: Text(l.startNavigation),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openNavigation(Trail item) async {
    final startPoint = item.startPoint;
    if (startPoint == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${startPoint.latitude},${startPoint.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
