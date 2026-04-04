import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/accommodation_model.dart';
import 'auth_provider.dart';

final accommodationsProvider = StreamProvider<List<Accommodation>>((ref) {
  return ref.watch(firestoreServiceProvider).watchAccommodations();
});

final accommodationProvider =
    FutureProvider.family<Accommodation?, String>((ref, id) {
  return ref.read(firestoreServiceProvider).getAccommodation(id);
});
