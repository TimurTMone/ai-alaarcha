import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/accommodation_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../widgets/accommodation_card.dart';

class AccommodationsListScreen extends ConsumerWidget {
  const AccommodationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final accommodations = ref.watch(accommodationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_titleLabel(locale))),
      body: accommodations.when(
        data: (items) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _heroTitle(locale),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _heroSubtitle(locale, items.length),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(child: Text(l.noResults)),
              )
            else
              for (final item in items) ...[
                AccommodationCard(
                  accommodation: item,
                  onTap: () => context.push('/accommodations/${item.id}'),
                ),
                const SizedBox(height: 18),
              ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.error)),
      ),
    );
  }

  static String _titleLabel(String locale) =>
      {
        'en': 'Ala-Archa stays',
        'ru': 'Проживание в Ала-Арче',
        'ky': 'Ала-Арчадагы жашоо жайы',
      }[locale] ??
      'Проживание в Ала-Арче';

  static String _heroTitle(String locale) =>
      {
        'en': 'Official park stays',
        'ru': 'Официальные объекты размещения',
        'ky': 'Расмий жайгашуу объекттери',
      }[locale] ??
      'Официальные объекты размещения';

  static String _heroSubtitle(String locale, int count) {
    return switch (locale) {
      'en' => '$count official options from the park price list in one list.',
      'ky' =>
        '$count расмий вариант парктын прейскурантынын негизинде көрсөтүлдү.',
      _ => '$count официальных вариантов из прейскуранта парка в одном списке.',
    };
  }
}
