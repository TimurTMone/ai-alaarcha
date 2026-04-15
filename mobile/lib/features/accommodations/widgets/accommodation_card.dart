import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/accommodation_model.dart';
import 'accommodation_image_backdrop.dart';
import 'accommodation_presentation.dart';

class AccommodationCard extends StatelessWidget {
  final Accommodation accommodation;
  final VoidCallback onTap;

  const AccommodationCard({
    super.key,
    required this.accommodation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final topAmenities = accommodation.amenities.take(3).toList();

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: AccommodationImageBackdrop(
                accommodation: accommodation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _GlassChip(
                            icon: Icons.hotel_class_rounded,
                            label: AccommodationPresentation.typeLabel(
                              accommodation.type,
                              locale,
                            ),
                          ),
                          const Spacer(),
                          if (accommodation.rating > 0)
                            _GlassChip(
                              icon: Icons.star_rounded,
                              label:
                                  '${accommodation.rating.toStringAsFixed(1)} · ${accommodation.reviewCount}',
                            ),
                        ],
                      ),
                      const Spacer(),
                      if (accommodation.includesGondola)
                        _GlassChip(
                          icon: Icons.tram_rounded,
                          label: _gondolaLabel(locale),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          accommodation.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: AppColors.textPrimary,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AccommodationPresentation.priceLabel(accommodation),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            AccommodationPresentation.perNightLabel(locale),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    accommodation.localizedDescription(locale),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoPill(
                        icon: Icons.people_alt_outlined,
                        label: AccommodationPresentation.guestCapacityLabel(
                          accommodation.capacity,
                          locale,
                        ),
                      ),
                      for (final amenity in topAmenities)
                        _InfoPill(
                          icon: AccommodationPresentation.amenityIcon(amenity),
                          label: AccommodationPresentation.amenityLabel(
                            amenity,
                            locale,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        _detailsLabel(locale),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _detailsLabel(String locale) =>
      {
        'en': 'View details',
        'ru': 'Посмотреть детали',
        'ky': 'Толугураак көрүү',
      }[locale] ??
      'Посмотреть детали';

  static String _gondolaLabel(String locale) =>
      {
        'en': 'Gondola included',
        'ru': 'Канатка включена',
        'ky': 'Канат жолу кошулган',
      }[locale] ??
      'Канатка включена';
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
