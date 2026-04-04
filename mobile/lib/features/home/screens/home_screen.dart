import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../widgets/weather_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/featured_places.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.welcome,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          user.when(
                            data: (u) => Text(
                              u?.displayName ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, _) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    // SOS Button
                    IconButton(
                      onPressed: () => context.push('/sos'),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.sosBackground,
                        foregroundColor: AppColors.sos,
                      ),
                      icon: const Icon(Icons.sos, size: 28),
                    ),
                  ],
                ),
              ),
            ),

            // Weather Card
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: WeatherCard(),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: QuickActions(
                  onBuyPass: () => context.push('/passes/buy'),
                  onMyPasses: () => context.push('/passes'),
                  onGondola: () => context.push('/accommodations'),
                  onTours: () => context.push('/tours'),
                ),
              ),
            ),

            // Featured Places
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
                child: FeaturedPlaces(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
