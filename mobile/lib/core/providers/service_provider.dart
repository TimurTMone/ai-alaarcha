import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mocks/mock_services.dart';
import '../models/service_model.dart';

final servicesProvider = Provider<List<Service>>((ref) => MockServices.all);

final servicesByCategoryProvider =
    Provider.family<List<Service>, ServiceCategory>((ref, category) {
  return ref
      .watch(servicesProvider)
      .where((s) => s.category == category)
      .toList();
});

final serviceByIdProvider = Provider.family<Service?, String>((ref, id) {
  final services = ref.watch(servicesProvider);
  for (final s in services) {
    if (s.id == id) return s;
  }
  return null;
});
