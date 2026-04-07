import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/service_model.dart';
import '../../../core/providers/service_provider.dart';

class ServiceDetailScreen extends ConsumerWidget {
  const ServiceDetailScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final service = ref.watch(serviceByIdProvider(serviceId));

    if (service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Service not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          service.localizedName(locale),
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero: show first image or placeholder
            if (service.images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  service.images.first,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _heroPlaceholder(service),
                ),
              )
            else
              _heroPlaceholder(service),
            const SizedBox(height: 20),
            if (service.venue != null)
              Text(
                service.venue!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryDark,
                  letterSpacing: 0.6,
                ),
              ),
            if (service.venue != null) const SizedBox(height: 6),
            Text(
              service.localizedName(locale),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              service.localizedDescription(locale),
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            _InfoRow(
              icon: Icons.payments_outlined,
              label: _priceLabel(locale),
              value:
                  '${_formatPrice(service.priceKgs)} KGS ${_unitLabel(service.unit, locale)}'
                      .trim(),
            ),
            if (service.capacity != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.group_outlined,
                label: _capacityLabel(locale),
                value: '${service.capacity}',
              ),
            ],
            if (service.phone != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: _phoneLabel(locale),
                value: service.phone!,
              ),
            ],
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push('/services/$serviceId/book'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  _bookLabel(locale),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
    return labels[u]?[locale] ?? labels[u]?['ru'] ?? '';
  }

  static String _priceLabel(String l) =>
      {'en': 'Price', 'ru': 'Цена', 'ky': 'Баасы'}[l] ?? 'Цена';
  static String _capacityLabel(String l) =>
      {'en': 'Capacity', 'ru': 'Вместимость', 'ky': 'Сыйымдуулук'}[l] ??
      'Вместимость';
  static String _bookLabel(String l) =>
      {'en': 'Book Now', 'ru': 'Забронировать', 'ky': 'Брондоо'}[l] ??
      'Забронировать';
  static String _phoneLabel(String l) =>
      {'en': 'Phone', 'ru': 'Телефон', 'ky': 'Телефон'}[l] ?? 'Телефон';

  static Widget _heroPlaceholder(Service service) => Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Icon(
            _iconFor(service.category),
            size: 72,
            color: AppColors.primary,
          ),
        ),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
