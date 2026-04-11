import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/data/ala_archa_map_data.dart';
import '../../../core/models/trail_model.dart';

class TrailMapWidget extends StatefulWidget {
  const TrailMapWidget({
    super.key,
    required this.trails,
    this.compact = false,
    this.selectedRouteId,
    this.selectedFeatureId,
    this.onSelectRoute,
    this.onSelectFeature,
  });

  final List<Trail> trails;
  final bool compact;
  final String? selectedRouteId;
  final String? selectedFeatureId;
  final ValueChanged<String>? onSelectRoute;
  final ValueChanged<String>? onSelectFeature;

  @override
  State<TrailMapWidget> createState() => _TrailMapWidgetState();
}

class _TrailMapWidgetState extends State<TrailMapWidget> {
  final _mapController = MapController();
  bool _showTopo = true;

  List<AlaArchaMapRoute> get _routes {
    if (!widget.compact) return AlaArchaMapData.routes;
    final ids = widget.trails.map((t) => t.id).toSet();
    final filtered = AlaArchaMapData.routes
        .where((route) => ids.contains(route.id))
        .toList();
    return filtered.isEmpty ? AlaArchaMapData.routes : filtered;
  }

  List<LatLng> get _allPoints => [
    for (final route in _routes) ...route.path,
    for (final feature in AlaArchaMapData.features) feature.position,
  ];

  @override
  void didUpdateWidget(covariant TrailMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRouteId != widget.selectedRouteId ||
        oldWidget.selectedFeatureId != widget.selectedFeatureId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusSelection());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allPoints.isEmpty) return _MapFallback(compact: widget.compact);

    final bounds = LatLngBounds.fromPoints(_allPoints);

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.compact ? 14 : 18),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: AlaArchaMapData.defaultCenter,
              initialZoom: 13,
              minZoom: 11,
              initialCameraFit: CameraFit.bounds(
                bounds: bounds,
                padding: EdgeInsets.all(widget.compact ? 28 : 40),
              ),
              onTap: (_, point) => _selectNearestRoute(point),
            ),
            children: [
              TileLayer(
                urlTemplate: _showTopo
                    ? 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: _showTopo ? const ['a', 'b', 'c'] : const [],
                userAgentPackageName: 'com.alaarchapark.ala_archa',
              ),
              PolylineLayer(polylines: _routePolylines()),
              MarkerLayer(markers: _featureMarkers(context)),
              RichAttributionWidget(
                showFlutterMapAttribution: false,
                attributions: [
                  TextSourceAttribution(
                    _showTopo
                        ? 'OpenTopoMap, OpenStreetMap contributors'
                        : 'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                      Uri.parse('https://www.openstreetmap.org/copyright'),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 12,
            right: 12,
            child: _MapControls(
              showTopo: _showTopo,
              onToggleLayer: () => setState(() => _showTopo = !_showTopo),
              onReset: _fitAll,
            ),
          ),
          if (widget.selectedRouteId != null ||
              widget.selectedFeatureId != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: _SelectionBanner(
                routeId: widget.selectedRouteId,
                featureId: widget.selectedFeatureId,
              ),
            ),
        ],
      ),
    );
  }

  List<Polyline> _routePolylines() {
    final selectedId = widget.selectedRouteId;
    return [
      for (final route in _routes)
        Polyline(
          points: route.path,
          strokeWidth: selectedId == route.id ? 6 : 4,
          color: _routeColor(route.difficulty).withValues(
            alpha: selectedId == null || selectedId == route.id ? 0.92 : 0.25,
          ),
          borderStrokeWidth: selectedId == route.id ? 2 : 1,
          borderColor: Colors.white.withValues(alpha: 0.85),
        ),
    ];
  }

  List<Marker> _featureMarkers(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final destinationIds = _routes.map((route) => route.destinationId).toSet()
      ..add('alplager');
    return [
      for (final feature in AlaArchaMapData.features)
        if (!widget.compact || destinationIds.contains(feature.id))
          Marker(
            point: feature.position,
            width: widget.selectedFeatureId == feature.id ? 58 : 46,
            height: widget.selectedFeatureId == feature.id ? 58 : 46,
            child: GestureDetector(
              onTap: () => widget.onSelectFeature?.call(feature.id),
              child: Tooltip(
                message: AlaArchaMapData.getLocalizedText(feature.name, locale),
                child: _FeaturePin(
                  feature: feature,
                  selected: widget.selectedFeatureId == feature.id,
                ),
              ),
            ),
          ),
    ];
  }

  void _focusSelection() {
    final routeId = widget.selectedRouteId;
    if (routeId != null) {
      final route = AlaArchaMapData.getRouteById(routeId);
      if (route != null) {
        _fitPoints(route.path, padding: widget.compact ? 34 : 58);
        return;
      }
    }

    final featureId = widget.selectedFeatureId;
    if (featureId != null) {
      final feature = AlaArchaMapData.getFeatureById(featureId);
      if (feature != null) {
        _mapController.move(feature.position, widget.compact ? 14.5 : 15);
        return;
      }
    }

    _fitAll();
  }

  void _fitAll() => _fitPoints(_allPoints, padding: widget.compact ? 28 : 42);

  void _fitPoints(List<LatLng> points, {required double padding}) {
    if (points.isEmpty) return;
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: EdgeInsets.all(padding),
      ),
    );
  }

  void _selectNearestRoute(LatLng tapped) {
    if (widget.onSelectRoute == null) return;
    const distance = Distance();
    AlaArchaMapRoute? nearest;
    var nearestMeters = double.infinity;

    for (final route in _routes) {
      for (var i = 0; i < route.path.length - 1; i++) {
        final meters = _distanceToSegment(
          tapped,
          route.path[i],
          route.path[i + 1],
          distance,
        );
        if (meters < nearestMeters) {
          nearestMeters = meters;
          nearest = route;
        }
      }
    }

    if (nearest != null && nearestMeters < 180) {
      widget.onSelectRoute?.call(nearest.id);
    }
  }

  double _distanceToSegment(
    LatLng point,
    LatLng a,
    LatLng b,
    Distance distance,
  ) {
    final latScale = 111320.0;
    final lonScale = 111320.0 * math.cos(point.latitudeInRad);
    final px = point.longitude * lonScale;
    final py = point.latitude * latScale;
    final ax = a.longitude * lonScale;
    final ay = a.latitude * latScale;
    final bx = b.longitude * lonScale;
    final by = b.latitude * latScale;
    final dx = bx - ax;
    final dy = by - ay;

    if (dx == 0 && dy == 0) return distance(point, a);
    final t = (((px - ax) * dx) + ((py - ay) * dy)) / ((dx * dx) + (dy * dy));
    final clamped = t.clamp(0.0, 1.0);
    final projection = LatLng(
      (ay + clamped * dy) / latScale,
      (ax + clamped * dx) / lonScale,
    );
    return distance(point, projection);
  }

  Color _routeColor(AlaArchaRouteDifficulty difficulty) {
    switch (difficulty) {
      case AlaArchaRouteDifficulty.easy:
        return AppColors.success;
      case AlaArchaRouteDifficulty.moderate:
        return AppColors.warning;
      case AlaArchaRouteDifficulty.hard:
        return AppColors.error;
    }
  }
}

class _FeaturePin extends StatelessWidget {
  const _FeaturePin({required this.feature, required this.selected});

  final AlaArchaMapFeature feature;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = _featureColor(feature.category);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: selected ? 4 : 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: selected ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(_featureIcon(feature.category), color: color, size: 22),
    );
  }

  Color _featureColor(AlaArchaFeatureCategory category) {
    switch (category) {
      case AlaArchaFeatureCategory.trailhead:
        return AppColors.primary;
      case AlaArchaFeatureCategory.waterfall:
        return AppColors.info;
      case AlaArchaFeatureCategory.hut:
        return AppColors.secondaryDark;
      case AlaArchaFeatureCategory.viewpoint:
        return AppColors.success;
      case AlaArchaFeatureCategory.attraction:
        return AppColors.warning;
      case AlaArchaFeatureCategory.peak:
        return AppColors.error;
      case AlaArchaFeatureCategory.memorial:
        return AppColors.textSecondary;
    }
  }

  IconData _featureIcon(AlaArchaFeatureCategory category) {
    switch (category) {
      case AlaArchaFeatureCategory.trailhead:
        return Icons.flag;
      case AlaArchaFeatureCategory.waterfall:
        return Icons.water_drop;
      case AlaArchaFeatureCategory.hut:
        return Icons.cabin;
      case AlaArchaFeatureCategory.viewpoint:
        return Icons.visibility;
      case AlaArchaFeatureCategory.attraction:
        return Icons.favorite;
      case AlaArchaFeatureCategory.peak:
        return Icons.terrain;
      case AlaArchaFeatureCategory.memorial:
        return Icons.account_balance;
    }
  }
}

class _MapControls extends StatelessWidget {
  const _MapControls({
    required this.showTopo,
    required this.onToggleLayer,
    required this.onReset,
  });

  final bool showTopo;
  final VoidCallback onToggleLayer;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: showTopo ? 'OpenStreetMap' : 'OpenTopoMap',
            onPressed: onToggleLayer,
            icon: Icon(showTopo ? Icons.layers : Icons.terrain),
          ),
          IconButton(
            tooltip: 'Показать всё',
            onPressed: onReset,
            icon: const Icon(Icons.center_focus_strong),
          ),
        ],
      ),
    );
  }
}

class _SelectionBanner extends StatelessWidget {
  const _SelectionBanner({this.routeId, this.featureId});

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
    final subtitle = route != null
        ? '${route.distanceKm.toStringAsFixed(1)} km'
        : feature?.elevationMeters != null
        ? '${feature!.elevationMeters} m'
        : '';

    return Material(
      color: Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.place, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(width: 10),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MapFallback extends StatelessWidget {
  const _MapFallback({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Для этого маршрута пока нет координат.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 12 : 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
