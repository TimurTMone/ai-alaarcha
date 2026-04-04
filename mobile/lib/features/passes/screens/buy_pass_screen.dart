import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/pass_model.dart';
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

  int get _currentPrice =>
      _prices[(_selectedType, _selectedCategory)] ?? 0;

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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<PassType>(
              segments: [
                ButtonSegment(value: PassType.day, label: Text(l.dayPass)),
                ButtonSegment(
                    value: PassType.multiDay, label: Text(l.multiDayPass)),
                ButtonSegment(value: PassType.annual, label: Text(l.annualPass)),
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
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
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
                      onPressed: () {
                        // TODO: Payment flow
                      },
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
