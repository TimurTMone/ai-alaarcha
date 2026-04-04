import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../mocks/mock_data.dart';
import '../models/trail_model.dart';
import 'auth_provider.dart';

final trailsProvider = StreamProvider<List<Trail>>((ref) {
  if (AppConfig.devMode) return Stream.value(MockData.trails);
  return ref.watch(firestoreServiceProvider).watchTrails();
});

final trailProvider = FutureProvider.family<Trail?, String>((ref, id) async {
  if (AppConfig.devMode) {
    return MockData.trails.firstWhere(
      (t) => t.id == id,
      orElse: () => MockData.trails.first,
    );
  }
  return ref.read(firestoreServiceProvider).getTrail(id);
});
