import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_config.dart';
import '../mocks/mock_data.dart';
import '../models/accommodation_model.dart';
import 'auth_provider.dart';

final accommodationsProvider = StreamProvider<List<Accommodation>>((ref) {
  if (AppConfig.devMode) return Stream.value(MockData.accommodations);
  return ref.watch(firestoreServiceProvider).watchAccommodations();
});

final accommodationProvider = FutureProvider.family<Accommodation?, String>((
  ref,
  id,
) async {
  if (AppConfig.devMode) {
    for (final accommodation in MockData.accommodations) {
      if (accommodation.id == id) return accommodation;
    }
    return null;
  }
  return ref.read(firestoreServiceProvider).getAccommodation(id);
});
