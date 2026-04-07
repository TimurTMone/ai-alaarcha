import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../mocks/mock_services.dart';
import '../models/service_model.dart';

/// Streams all active services. In devMode, returns the hardcoded mocks.
final servicesProvider = StreamProvider<List<Service>>((ref) {
  if (AppConfig.devMode) return Stream.value(MockServices.all);
  return FirebaseFirestore.instance
      .collection('services')
      .where('isActive', isEqualTo: true)
      .snapshots()
      .map((snap) => snap.docs.map(Service.fromFirestore).toList());
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
