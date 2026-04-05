import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/service_model.dart';
import '../../../core/providers/service_provider.dart';

class ServicesSection extends ConsumerWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final services = ref.watch(servicesProvider);

    final byCategory = <ServiceCategory, List<Service>>{};
    for (final s in services) {
      byCategory.putIfAbsent(s.category, () => []).add(s);
    }

    const categoryOrder = [
      ServiceCategory.hotel,
      ServiceCategory.venue,
      ServiceCategory.recreation,
      ServiceCategory.rental,
      ServiceCategory.extra,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final category in categoryOrder)
          if ((byCategory[category] ?? const []).isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Icon(
                    _iconFor(category),
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _titleFor(category, locale),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 152,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: byCategory[category]!.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) =>
                    _ServiceCard(service: byCategory[category]![i], locale: locale),
              ),
            ),
          ],
      ],
    );
  }

  static IconData _iconFor(ServiceCategory c) => switch (c) {
        ServiceCategory.hotel => Icons.hotel,
        ServiceCategory.venue => Icons.meeting_room,
        ServiceCategory.recreation => Icons.park,
        ServiceCategory.rental => Icons.pedal_bike,
        ServiceCategory.extra => Icons.miscellaneous_services,
      };

  static String _titleFor(ServiceCategory c, String locale) {
    const titles = {
      ServiceCategory.hotel: {
        'en': 'Hotels',
        'ru': 'Гостиницы',
        'ky': 'Мейманканалар',
      },
      ServiceCategory.venue: {
        'en': 'Halls & Venues',
        'ru': 'Залы и площадки',
        'ky': 'Залдар жана аянттар',
      },
      ServiceCategory.recreation: {
        'en': 'Recreation',
        'ru': 'Отдых',
        'ky': 'Эс алуу',
      },
      ServiceCategory.rental: {
        'en': 'Activities & Rentals',
        'ru': 'Активности и прокат',
        'ky': 'Активдүүлүк жана ижара',
      },
      ServiceCategory.extra: {
        'en': 'Additional Services',
        'ru': 'Доп. услуги',
        'ky': 'Кошумча кызматтар',
      },
    };
    final m = titles[c]!;
    return m[locale] ?? m['ru']!;
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.locale});

  final Service service;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/services/${service.id}'),
          child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (service.venue != null)
                Text(
                  service.venue!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryDark,
                    letterSpacing: 0.3,
                  ),
                ),
              if (service.venue != null) const SizedBox(height: 4),
              Text(
                service.localizedName(locale),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  service.localizedDescription(locale),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _formatPrice(service.priceKgs),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'KGS',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _unitLabel(service.unit, locale),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  static String _formatPrice(int kgs) {
    final s = kgs.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static String _unitLabel(PriceUnit u, String locale) {
    const labels = {
      PriceUnit.perNight: {'en': '/ night', 'ru': '/ ночь', 'ky': '/ түнгө'},
      PriceUnit.perHour: {'en': '/ hour', 'ru': '/ час', 'ky': '/ саат'},
      PriceUnit.perDay: {'en': '/ day', 'ru': '/ день', 'ky': '/ күн'},
      PriceUnit.perPerson: {'en': '/ person', 'ru': '/ чел.', 'ky': '/ киши'},
      PriceUnit.perTable: {'en': '/ table', 'ru': '/ стол', 'ky': '/ үстөл'},
      PriceUnit.perItem: {'en': '/ item', 'ru': '/ шт.', 'ky': '/ даана'},
      PriceUnit.flat: {'en': '', 'ru': '', 'ky': ''},
    };
    final m = labels[u]!;
    return m[locale] ?? m['ru']!;
  }
}
