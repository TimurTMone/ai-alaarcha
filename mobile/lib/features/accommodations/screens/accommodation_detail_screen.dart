import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/accommodation_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../widgets/accommodation_image_backdrop.dart';
import '../widgets/accommodation_presentation.dart';

class AccommodationDetailScreen extends ConsumerWidget {
  final String accommodationId;

  const AccommodationDetailScreen({super.key, required this.accommodationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final accommodation = ref.watch(accommodationProvider(accommodationId));

    return Scaffold(
      body: accommodation.when(
        data: (item) {
          if (item == null) {
            return Center(child: Text(l.noResults));
          }

          final amenities = item.amenities.take(6).toList();

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 340,
                child: AccommodationImageBackdrop(
                  accommodation: item,
                  showPlaceholderIcon: false,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.12,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.arrow_back_rounded),
                              ),
                              const Spacer(),
                              _HeroChip(
                                icon: Icons.chat_bubble_outline_rounded,
                                label: _whatsAppHint(locale),
                              ),
                            ],
                          ),
                          const Spacer(),
                          _HeroChip(
                            icon: Icons.hotel_class_rounded,
                            label: AccommodationPresentation.typeLabel(
                              item.type,
                              locale,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 260,
                            child: Text(
                              item.localizedDescription(locale),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                height: 1.45,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _HeroChip(
                                icon: Icons.payments_outlined,
                                label: AccommodationPresentation.priceLabel(
                                  item,
                                ),
                              ),
                              _HeroChip(
                                icon: Icons.people_alt_outlined,
                                label:
                                    AccommodationPresentation.guestCapacityLabel(
                                      item.capacity,
                                      locale,
                                    ),
                              ),
                              if (item.includesGondola)
                                _HeroChip(
                                  icon: Icons.tram_rounded,
                                  label: l.includesGondola,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoCard(
                      children: [
                        _DetailRow(
                          icon: Icons.people_alt_outlined,
                          label: _capacityLabel(locale),
                          value: AccommodationPresentation.guestCapacityLabel(
                            item.capacity,
                            locale,
                          ),
                        ),
                        _DetailRow(
                          icon: Icons.phone_outlined,
                          label: _contactLabel(locale),
                          value: AccommodationPresentation.bookingPhone(item),
                        ),
                        _DetailRow(
                          icon: Icons.payments_outlined,
                          label: _priceLabel(locale),
                          value:
                              '${AccommodationPresentation.priceLabel(item)} · ${AccommodationPresentation.perNightLabel(locale)}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _aboutLabel(locale),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.localizedDescription(locale),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l.amenities,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final amenity in amenities)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  AccommodationPresentation.amenityIcon(
                                    amenity,
                                  ),
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AccommodationPresentation.amenityLabel(
                                    amenity,
                                    locale,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _InfoCard(
                      title: _howItWorksLabel(locale),
                      children: [
                        _ProcessRow(number: '1', text: _processOne(locale)),
                        _ProcessRow(number: '2', text: _processTwo(locale)),
                        _ProcessRow(number: '3', text: _processThree(locale)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.error)),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              final item = accommodation.valueOrNull;
              if (item == null) return;
              context.push('/accommodations/${item.id}/book');
            },
            icon: const Icon(Icons.calendar_month_rounded),
            label: Text(_bookingButtonLabel(locale)),
          ),
        ),
      ),
    );
  }

  static String _bookingButtonLabel(String locale) =>
      {
        'en': 'Continue to booking',
        'ru': 'Перейти к бронированию',
        'ky': 'Брондоого өтүү',
      }[locale] ??
      'Перейти к бронированию';

  static String _whatsAppHint(String locale) =>
      {
        'en': 'WhatsApp request',
        'ru': 'Заявка в WhatsApp',
        'ky': 'WhatsApp арызы',
      }[locale] ??
      'Заявка в WhatsApp';

  static String _capacityLabel(String locale) =>
      {'en': 'Capacity', 'ru': 'Вместимость', 'ky': 'Сыйымдуулук'}[locale] ??
      'Вместимость';

  static String _contactLabel(String locale) =>
      {'en': 'Contact', 'ru': 'Контакт', 'ky': 'Байланыш'}[locale] ?? 'Контакт';

  static String _priceLabel(String locale) =>
      {'en': 'Price', 'ru': 'Цена', 'ky': 'Баасы'}[locale] ?? 'Цена';

  static String _aboutLabel(String locale) =>
      {
        'en': 'About this stay',
        'ru': 'О проживании',
        'ky': 'Жашоо жайы тууралуу',
      }[locale] ??
      'О проживании';

  static String _howItWorksLabel(String locale) =>
      {
        'en': 'How booking works',
        'ru': 'Как проходит бронирование',
        'ky': 'Брондоо кантип иштейт',
      }[locale] ??
      'Как проходит бронирование';

  static String _processOne(String locale) =>
      {
        'en': 'Choose convenient dates and number of guests.',
        'ru': 'Выберите удобные даты и количество гостей.',
        'ky': 'Ыңгайлуу күндөрдү жана коноктор санын тандаңыз.',
      }[locale] ??
      'Выберите удобные даты и количество гостей.';

  static String _processTwo(String locale) =>
      {
        'en': 'Tap the green WhatsApp button on the next screen.',
        'ru': 'На следующем экране нажмите зеленую кнопку WhatsApp.',
        'ky': 'Кийинки экранда жашыл WhatsApp баскычын басыңыз.',
      }[locale] ??
      'На следующем экране нажмите зеленую кнопку WhatsApp.';

  static String _processThree(String locale) =>
      {
        'en':
            'A ready-made message will open and the manager will confirm the stay.',
        'ru': 'Откроется готовое сообщение, и менеджер подтвердит проживание.',
        'ky': 'Даяр билдирүү ачылып, менеджер жашоону ырастайт.',
      }[locale] ??
      'Откроется готовое сообщение, и менеджер подтвердит проживание.';
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

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

class _InfoCard extends StatelessWidget {
  const _InfoCard({this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessRow extends StatelessWidget {
  const _ProcessRow({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
