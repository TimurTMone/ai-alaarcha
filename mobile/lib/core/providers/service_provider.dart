import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../mocks/mock_services.dart';
import '../models/service_model.dart';
import '../services/backend_api_service.dart';

final backendApiProvider =
    Provider<BackendApiService>((ref) => BackendApiService());

final servicesProvider = FutureProvider<List<Service>>((ref) async {
  if (AppConfig.useBackendContent) {
    return ref.watch(backendApiProvider).fetchServices();
  }
  if (AppConfig.devMode) return MockServices.all;
  return MockServices.all;
});

final servicesByCategoryProvider =
    Provider.family<List<Service>, ServiceCategory>((ref, category) {
  final all = ref.watch(servicesProvider).valueOrNull ?? const [];
  return all.where((s) => s.category == category).toList();
});

final serviceByIdProvider = Provider.family<Service?, String>((ref, id) {
  final all = ref.watch(servicesProvider).valueOrNull ?? const [];
  for (final s in all) {
    if (s.id == id) return s;
  }
  return null;
});
