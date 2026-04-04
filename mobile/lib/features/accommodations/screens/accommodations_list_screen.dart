import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/accommodation_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../widgets/accommodation_card.dart';

class AccommodationsListScreen extends ConsumerWidget {
  const AccommodationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final accommodations = ref.watch(accommodationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.accommodations)),
      body: accommodations.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, i) => AccommodationCard(
            accommodation: items[i],
            onTap: () => context.push('/accommodations/${items[i].id}'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.error)),
      ),
    );
  }
}
