import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/accommodation_model.dart';
import '../../../core/providers/accommodation_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../accommodations/widgets/accommodation_card.dart';
import '../../accommodations/widgets/accommodation_image_backdrop.dart';
import '../../accommodations/widgets/accommodation_presentation.dart';
import '../widgets/quick_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final user = ref.watch(currentUserProvider).valueOrNull;
    final accommodations = ref.watch(accommodationsProvider);
    final featuredStay = _featuredAccommodation(accommodations.valueOrNull);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            Padding(
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
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user?.displayName?.trim().isNotEmpty == true
                              ? user!.displayName!
                              : _subtitleLabel(locale),
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/sos'),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.sosBackground,
                      foregroundColor: AppColors.sos,
                      padding: const EdgeInsets.all(14),
                    ),
                    icon: const Icon(Icons.sos, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _AFrameBanner(
              locale: locale,
              featuredStay: featuredStay,
              onBook: () {
                if (featuredStay != null) {
                  context.push('/accommodations/${featuredStay.id}/book');
                  return;
                }
                context.go('/accommodations');
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuickActions(
                    onBuyPass: () => context.push('/passes/buy'),
                    onMyPasses: () => context.push('/passes'),
                    onStays: () => context.go('/accommodations'),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    _staysTitle(locale),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _staysSubtitle(locale),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  accommodations.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Center(child: Text(l.noResults)),
                        );
                      }
                      return Column(
                        children: [
                          for (final item in items) ...[
                            AccommodationCard(
                              accommodation: item,
                              onTap: () =>
                                  context.push('/accommodations/${item.id}'),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ],
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(l.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Accommodation? _featuredAccommodation(List<Accommodation>? items) {
    if (items == null || items.isEmpty) return null;
    for (final item in items) {
      if (item.type == AccommodationType.aFrame) return item;
    }
    return items.first;
  }

  static String _subtitleLabel(String locale) =>
      {
        'en': 'Official park stays with live photos and booking contacts.',
        'ru':
            'Официальные варианты проживания в Ала-Арче с реальными фото и контактами для бронирования.',
        'ky':
            'Ала-Арчадагы расмий жашоо жайлары, чыныгы сүрөттөр жана брондоо байланыштары менен.',
      }[locale] ??
      'Официальные варианты проживания в Ала-Арче с реальными фото и контактами для бронирования.';

  static String _staysTitle(String locale) =>
      {
        'en': 'Official stays in Ala-Archa',
        'ru': 'Официальные варианты проживания',
        'ky': 'Ала-Арчадагы расмий жашоо жайлары',
      }[locale] ??
      'Официальные варианты проживания';

  static String _staysSubtitle(String locale) =>
      {
        'en':
            'Cards are filled from the official park price list and park pages.',
        'ru':
            'Карточки заполнены по официальному прейскуранту и страницам природного парка «Ала-Арча».',
        'ky':
            'Карточкалар парктын расмий прейскуранты жана барактарынын негизинде толтурулду.',
      }[locale] ??
      'Карточки заполнены по официальному прейскуранту и страницам природного парка «Ала-Арча».';
}

class _AFrameBanner extends StatelessWidget {
  const _AFrameBanner({
    required this.locale,
    required this.featuredStay,
    required this.onBook,
  });

  final String locale;
  final Accommodation? featuredStay;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final stay = featuredStay;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bannerHeight = screenWidth < 390 ? 390.0 : 360.0;
    final fallback = Container(
      height: bannerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: _BannerContent(
        locale: locale,
        title: _fallbackTitle(locale),
        description: _fallbackDescription(locale),
        priceLabel: null,
        onBook: onBook,
      ),
    );

    return SizedBox(
      height: bannerHeight,
      width: double.infinity,
      child: stay == null
          ? fallback
          : AccommodationImageBackdrop(
              accommodation: stay,
              showPlaceholderIcon: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: _BannerContent(
                  locale: locale,
                  title: stay.name,
                  description: stay.localizedDescription(locale),
                  priceLabel: AccommodationPresentation.priceLabel(stay),
                  onBook: onBook,
                ),
              ),
            ),
    );
  }

  static String _fallbackTitle(String locale) =>
      {
        'en': 'Ala-Archa stays',
        'ru': 'Проживание в Ала-Арче',
        'ky': 'Ала-Арчадагы жашоо жайлары',
      }[locale] ??
      'Проживание в Ала-Арче';

  static String _fallbackDescription(String locale) =>
      {
        'en':
            'Real park stays with official contacts, current price list, and visual cards in Russian.',
        'ru':
            'Реальные варианты проживания в парке с официальными контактами, актуальным прейскурантом и фото в карточках.',
        'ky':
            'Парктагы чыныгы жашоо жайлары, расмий байланыштар, актуалдуу прейскурант жана сүрөттөр менен.',
      }[locale] ??
      'Реальные варианты проживания в парке с официальными контактами, актуальным прейскурантом и фото в карточках.';
}

class _BannerContent extends StatelessWidget {
  const _BannerContent({
    required this.locale,
    required this.title,
    required this.description,
    required this.priceLabel,
    required this.onBook,
  });

  final String locale;
  final String title;
  final String description;
  final String? priceLabel;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Text(
            _eyebrowLabel(locale),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const Spacer(),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.06,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 320,
          child: Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _BannerStat(
              icon: Icons.route_rounded,
              label: _distanceLabel(locale),
            ),
            _BannerStat(icon: Icons.eco_rounded, label: _foundedLabel(locale)),
            if (priceLabel != null)
              _BannerStat(icon: Icons.payments_outlined, label: priceLabel!),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onBook,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            minimumSize: const Size(0, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.calendar_month_rounded),
          label: Text(_bookLabel(locale)),
        ),
      ],
    );
  }

  static String _eyebrowLabel(String locale) =>
      {
        'en': 'Featured stay',
        'ru': 'Рекомендуем для поездки',
        'ky': 'Сапар үчүн сунуш',
      }[locale] ??
      'Рекомендуем для поездки';

  static String _distanceLabel(String locale) =>
      {
        'en': '17 km from the city',
        'ru': '17 км от города',
        'ky': 'Шаардан 17 км',
      }[locale] ??
      '17 км от города';

  static String _foundedLabel(String locale) =>
      {
        'en': 'Park since 1976',
        'ru': 'Парк с 1976 года',
        'ky': 'Парк 1976-жылдан бери',
      }[locale] ??
      'Парк с 1976 года';

  static String _bookLabel(String locale) =>
      {
        'en': 'Open booking',
        'ru': 'Открыть бронирование',
        'ky': 'Брондоону ачуу',
      }[locale] ??
      'Открыть бронирование';
}

class _BannerStat extends StatelessWidget {
  const _BannerStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
