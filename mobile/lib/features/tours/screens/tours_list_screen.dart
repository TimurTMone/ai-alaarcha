import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/mocks/mock_data.dart';
import '../../../core/models/tour_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/l10n_extension.dart';

final _toursProvider = StreamProvider<List<Tour>>((ref) {
  if (AppConfig.devMode) return Stream.value(MockData.tours);
  return ref.watch(firestoreServiceProvider).watchTours();
});

class ToursListScreen extends ConsumerWidget {
  const ToursListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final tours = ref.watch(_toursProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tours)),
      body: tours.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (_, i) {
            final tour = items[i];
            final typeIcon = switch (tour.type) {
              TourType.hiking => Icons.hiking,
              TourType.horse => Icons.pets,
              TourType.climbing => Icons.terrain,
              TourType.skiing => Icons.downhill_skiing,
              TourType.photo => Icons.camera_alt,
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
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(typeIcon, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tour.localizedName('ru'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${tour.durationFormatted} · ${tour.difficulty}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${tour.price.toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              '${l.maxParticipants}: ${tour.maxParticipants}',
                              style: const TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Tour booking flow
                        },
                        child: Text(l.bookTour),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.error)),
      ),
    );
  }
}
