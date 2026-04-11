import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/ala_archa_map_data.dart';
import '../../../core/models/trail_model.dart';
import '../../../core/providers/trail_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../widgets/trail_map_widget.dart';

class TrailsMapScreen extends ConsumerStatefulWidget {
  const TrailsMapScreen({super.key});

  @override
  ConsumerState<TrailsMapScreen> createState() => _TrailsMapScreenState();
}

class _TrailsMapScreenState extends ConsumerState<TrailsMapScreen> {
  String? _selectedRouteId;
  String? _selectedFeatureId;

  void _selectRoute(String routeId) {
    final route = AlaArchaMapData.getRouteById(routeId);
    setState(() {
      _selectedRouteId = routeId;
      _selectedFeatureId = route?.destinationId;
    });
  }

  void _selectFeature(String featureId) {
    setState(() {
      _selectedFeatureId = featureId;
      _selectedRouteId = null;
    });
  }

  void _resetMap() {
    setState(() {
      _selectedRouteId = null;
      _selectedFeatureId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final trails = ref.watch(trailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.trails),
        actions: [
          IconButton(
            onPressed: _resetMap,
            icon: const Icon(Icons.refresh),
            tooltip: 'Сбросить карту',
          ),
        ],
      ),
      body: trails.when(
        data: (items) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.trailMap,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Реальная карта парка с маршрутами из OpenStreetMap. Нажмите на линию, точку или маршрут в списке.',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 420,
                      child: TrailMapWidget(
                        trails: items,
                        selectedRouteId: _selectedRouteId,
                        selectedFeatureId: _selectedFeatureId,
                        onSelectRoute: _selectRoute,
                        onSelectFeature: _selectFeature,
                      ),
                    ),
                    if (_selectedRouteId != null ||
                        _selectedFeatureId != null) ...[
                      const SizedBox(height: 14),
                      _SelectedInfoCard(
                        routeId: _selectedRouteId,
                        featureId: _selectedFeatureId,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _PanelHeader(
                      title: 'Маршруты',
                      actionLabel: _selectedRouteId == null ? null : 'Сбросить',
                      onAction: _resetMap,
                    ),
                  ],
                ),
              ),
            ),
            SliverList.separated(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final trail = items[i];
                return Padding(
                  padding: EdgeInsets.fromLTRB(20, i == 0 ? 4 : 0, 20, 0),
                  child: _TrailCard(
                    trail: trail,
                    selected: _selectedRouteId == trail.id,
                    onTap: () => _selectRoute(trail.id),
                    onDetailsTap: () => context.push('/trails/${trail.id}'),
                  ),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 12),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.error)),
      ),
    );
  }
}

class _SelectedInfoCard extends StatelessWidget {
  const _SelectedInfoCard({this.routeId, this.featureId});

  final String? routeId;
  final String? featureId;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final route = routeId == null
        ? null
        : AlaArchaMapData.getRouteById(routeId!);
    final feature = featureId == null
        ? null
        : AlaArchaMapData.getFeatureById(featureId!);

    final title = route != null
        ? AlaArchaMapData.getLocalizedText(route.name, locale)
        : feature != null
        ? AlaArchaMapData.getLocalizedText(feature.name, locale)
        : '';
    final body = route != null
        ? AlaArchaMapData.getLocalizedText(route.description, locale)
        : feature != null
        ? AlaArchaMapData.getLocalizedText(feature.summary, locale)
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.16)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          if (route != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.straighten,
                  label: '${route.distanceKm.toStringAsFixed(1)} km',
                ),
                const SizedBox(width: 14),
                _InfoChip(
                  icon: Icons.terrain,
                  label: _difficultyLabel(route.difficulty, locale),
                ),
              ],
            ),
          ] else if (feature?.elevationMeters != null) ...[
            const SizedBox(height: 10),
            _InfoChip(
              icon: Icons.trending_up,
              label: '${feature!.elevationMeters} m',
            ),
          ],
        ],
      ),
    );
  }

  String _difficultyLabel(AlaArchaRouteDifficulty difficulty, String locale) {
    switch (difficulty) {
      case AlaArchaRouteDifficulty.easy:
        return locale == 'en'
            ? 'easy'
            : locale == 'ky'
            ? 'жеңил'
            : 'лёгкий';
      case AlaArchaRouteDifficulty.moderate:
        return locale == 'en'
            ? 'moderate'
            : locale == 'ky'
            ? 'орточо'
            : 'средний';
      case AlaArchaRouteDifficulty.hard:
        return locale == 'en'
            ? 'hard'
            : locale == 'ky'
            ? 'татаал'
            : 'сложный';
    }
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (actionLabel != null && onAction != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class _TrailCard extends StatelessWidget {
  final Trail trail;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDetailsTap;

  const _TrailCard({
    required this.trail,
    required this.selected,
    required this.onTap,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

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
        color: selected ? AppColors.primary.withValues(alpha: 0.06) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trail.localizedName(locale),
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
              Wrap(
                spacing: 16,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _InfoChip(icon: Icons.terrain, label: trail.difficulty),
                  _InfoChip(
                    icon: Icons.straighten,
                    label: '${trail.distance} km',
                  ),
                  _InfoChip(
                    icon: Icons.trending_up,
                    label: '${trail.elevationGain}m',
                  ),
                  _InfoChip(
                    icon: Icons.schedule,
                    label: trail.estimatedTimeFormatted,
                  ),
                  TextButton.icon(
                    onPressed: onDetailsTap,
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(locale == 'en' ? 'Details' : 'Подробнее'),
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
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
