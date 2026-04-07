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
    final servicesAsync = ref.watch(servicesProvider);
    final services = servicesAsync.valueOrNull ?? const <Service>[];

    if (services.isEmpty) return const SizedBox.shrink();

    final byCategory = <ServiceCategory, List<Service>>{};
    for (final s in services) {
      byCategory.putIfAbsent(s.category, () => []).add(s);
    }

    const categoryOrder = [
      ServiceCategory.entrance,
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
              height: 220,
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
        ServiceCategory.entrance => Icons.directions_car,
        ServiceCategory.hotel => Icons.hotel,
        ServiceCategory.venue => Icons.meeting_room,
        ServiceCategory.recreation => Icons.park,
        ServiceCategory.rental => Icons.pedal_bike,
        ServiceCategory.extra => Icons.miscellaneous_services,
      };

  static String _titleFor(ServiceCategory c, String locale) {
    const titles = {
      ServiceCategory.entrance: {
        'en': 'Park Entry',
        'ru': 'Въезд в парк',
        'ky': 'Паркка кирүү',
      },
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
    final hasImage = service.images.isNotEmpty;

    return SizedBox(
      width: 180,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => context.push('/services/${service.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or icon header
              SizedBox(
                height: 100,
                width: double.infinity,
                child: hasImage
                    ? Image.network(
                        service.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _iconPlaceholder(service),
                      )
                    : _iconPlaceholder(service),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (service.venue != null)
                        Text(
                          service.venue!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryDark,
                          ),
                        ),
                      Text(
                        service.localizedName(locale),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _formatPrice(service.priceKgs),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              'KGS ${_unitLabel(service.unit, locale)}',
                              style: const TextStyle(
                                fontSize: 10,
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
            ],
          ),
        ),
      ),
    );
  }

  static Widget _iconPlaceholder(Service service) => Container(
        color: AppColors.primary.withValues(alpha: 0.08),
        child: Center(
          child: Icon(
            ServicesSection._iconFor(service.category),
            size: 36,
            color: AppColors.primary,
          ),
        ),
      );

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
      PriceUnit.perVehicle: {'en': '/ vehicle', 'ru': '/ авто', 'ky': '/ унаа'},
      PriceUnit.flat: {'en': '', 'ru': '', 'ky': ''},
    };
    final m = labels[u]!;
    return m[locale] ?? m['ru']!;
  }
}
