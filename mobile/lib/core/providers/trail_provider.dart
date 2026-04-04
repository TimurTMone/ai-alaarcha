import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trail_model.dart';
import 'auth_provider.dart';

final trailsProvider = StreamProvider<List<Trail>>((ref) {
  return ref.watch(firestoreServiceProvider).watchTrails();
});

final trailProvider = FutureProvider.family<Trail?, String>((ref, id) {
  return ref.read(firestoreServiceProvider).getTrail(id);
});
