import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/pass_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/utils/l10n_extension.dart';

class BuyPassScreen extends ConsumerStatefulWidget {
  const BuyPassScreen({super.key});

  @override
  ConsumerState<BuyPassScreen> createState() => _BuyPassScreenState();
}

class _BuyPassScreenState extends ConsumerState<BuyPassScreen> {
  PassType _selectedType = PassType.day;
  PassCategory _selectedCategory = PassCategory.citizen;

  static const _prices = {
    (PassType.day, PassCategory.citizen): 100,
    (PassType.day, PassCategory.tourist): 500,
    (PassType.day, PassCategory.child): 50,
    (PassType.day, PassCategory.student): 70,
    (PassType.multiDay, PassCategory.citizen): 250,
    (PassType.multiDay, PassCategory.tourist): 1200,
    (PassType.multiDay, PassCategory.child): 125,
    (PassType.multiDay, PassCategory.student): 175,
    (PassType.annual, PassCategory.citizen): 2000,
    (PassType.annual, PassCategory.tourist): 10000,
    (PassType.annual, PassCategory.child): 1000,
    (PassType.annual, PassCategory.student): 1400,
  };

  int get _currentPrice => _prices[(_selectedType, _selectedCategory)] ?? 0;

  Future<void> _buyPass() async {
    final now = DateTime.now();
    final bookingId = 'pass-${now.microsecondsSinceEpoch}';
    final validTo = _validTo(_selectedType, now);
    final locale = Localizations.localeOf(context).languageCode;
    final userId = ref.read(currentUserProvider).valueOrNull?.uid ?? 'dev-user';
    final booking = Booking(
      id: bookingId,
      userId: userId,
      code: _shortCode(bookingId),
      subjectTitle: _passTitle(locale),
      subjectType: BookingSubject.pass,
      subjectId: 'pass:${_selectedType.name}:${_selectedCategory.name}',
      quantity: 1,
      startsAt: now,
      endsAt: validTo,
      totalPriceKgs: _currentPrice,
      status: BookingStatus.pendingPayment,
      createdAt: now,
    );

    if (AppConfig.devMode || AppConfig.useBackendBookings) {
      ref.read(devBookingsProvider.notifier).add(booking);
    } else {
      await ref.read(firestoreServiceProvider).createBooking(booking);
    }

    if (!mounted) return;
    context.push('/bookings/${booking.id}/pay');
  }

  DateTime _validTo(PassType type, DateTime from) {
    switch (type) {
      case PassType.day:
        return from.add(const Duration(days: 1));
      case PassType.multiDay:
        return from.add(const Duration(days: 3));
      case PassType.annual:
        return DateTime(from.year + 1, from.month, from.day);
    }
  }

  String _shortCode(String id) => id.length <= 6
      ? id.toUpperCase()
      : id.substring(id.length - 6).toUpperCase();

  String _passTitle(String locale) {
    final typeLabel = switch (_selectedType) {
      PassType.day => _pickLabel(
        locale,
        en: 'Day pass',
        ru: 'Дневной пропуск',
        ky: 'Күндүк пропуск',
      ),
      PassType.multiDay => _pickLabel(
        locale,
        en: 'Multi-day pass',
        ru: 'Многодневный пропуск',
        ky: 'Көп күндүк пропуск',
      ),
      PassType.annual => _pickLabel(
        locale,
        en: 'Annual pass',
        ru: 'Годовой пропуск',
        ky: 'Жылдык пропуск',
      ),
    };
    final categoryLabel = switch (_selectedCategory) {
      PassCategory.citizen => _pickLabel(
        locale,
        en: 'Citizen',
        ru: 'Гражданин',
        ky: 'Жаран',
      ),
      PassCategory.tourist => _pickLabel(
        locale,
        en: 'Tourist',
        ru: 'Турист',
        ky: 'Турист',
      ),
      PassCategory.child => _pickLabel(
        locale,
        en: 'Child',
        ru: 'Ребёнок',
        ky: 'Бала',
      ),
      PassCategory.student => _pickLabel(
        locale,
        en: 'Student',
        ru: 'Студент',
        ky: 'Студент',
      ),
    };
    return '$typeLabel · $categoryLabel';
  }

  String _pickLabel(
    String locale, {
    required String en,
    required String ru,
    required String ky,
  }) => locale == 'en'
      ? en
      : locale == 'ky'
      ? ky
      : ru;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.buyPass)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pass type selector
            Text(
              l.buyPass,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SegmentedButton<PassType>(
              segments: [
                ButtonSegment(value: PassType.day, label: Text(l.dayPass)),
                ButtonSegment(
                  value: PassType.multiDay,
                  label: Text(l.multiDayPass),
                ),
                ButtonSegment(
                  value: PassType.annual,
                  label: Text(l.annualPass),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (v) =>
                  setState(() => _selectedType = v.first),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return null;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return AppColors.textPrimary;
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Category selector
            ...PassCategory.values.map((cat) {
              final label = switch (cat) {
                PassCategory.citizen => l.citizen,
                PassCategory.tourist => l.tourist,
                PassCategory.child => l.child,
                PassCategory.student => l.student,
              };
              final price = _prices[(_selectedType, cat)] ?? 0;
              final selected = cat == _selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => setState(() => _selectedCategory = cat),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                        width: selected ? 2 : 1,
                      ),
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$price ${l.currency}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            // Total + Buy Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.total,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$_currentPrice ${l.currency}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentPrice > 0 ? _buyPass : null,
                      child: Text(l.buyPass),
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
}
