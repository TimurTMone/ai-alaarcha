import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../mocks/mock_data.dart';
import '../models/accommodation_model.dart';
import 'auth_provider.dart';

final accommodationsProvider = StreamProvider<List<Accommodation>>((ref) {
  if (AppConfig.devMode) return Stream.value(MockData.accommodations);
  return ref.watch(firestoreServiceProvider).watchAccommodations();
});

final accommodationProvider =
    FutureProvider.family<Accommodation?, String>((ref, id) async {
  if (AppConfig.devMode) {
    return MockData.accommodations.firstWhere(
      (a) => a.id == id,
      orElse: () => MockData.accommodations.first,
    );
  }
  return ref.read(firestoreServiceProvider).getAccommodation(id);
});
