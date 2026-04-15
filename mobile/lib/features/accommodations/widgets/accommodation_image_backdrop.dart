import 'package:flutter/material.dart';
import '../../../core/models/accommodation_model.dart';
import 'accommodation_presentation.dart';

class AccommodationImageBackdrop extends StatelessWidget {
  const AccommodationImageBackdrop({
    super.key,
    required this.accommodation,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.showPlaceholderIcon = true,
    this.placeholderIconSize = 72,
  });

  final Accommodation accommodation;
  final Widget child;
  final BorderRadius borderRadius;
  final bool showPlaceholderIcon;
  final double placeholderIconSize;

  @override
  Widget build(BuildContext context) {
    final imageUrl = AccommodationPresentation.primaryImage(accommodation);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _fallback(),
            )
          else
            _fallback(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.28),
                  Colors.black.withValues(alpha: 0.62),
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _fallback() {
    final colors = AccommodationPresentation.gradientFor(accommodation);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: showPlaceholderIcon
          ? Center(
              child: Icon(
                AccommodationPresentation.iconFor(accommodation.type),
                size: placeholderIconSize,
                color: Colors.white.withValues(alpha: 0.28),
              ),
            )
          : null,
    );
  }
}
