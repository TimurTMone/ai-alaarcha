import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_config.dart';
import '../models/announcement_model.dart';
import 'service_provider.dart';

final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  if (AppConfig.useBackendContent) {
    final items = await ref.watch(backendApiProvider).fetchNews();
    return items.where((a) => !a.isExpired).toList();
  }
  return const [];
});

final announcementByIdProvider =
    FutureProvider.family<Announcement?, String>((ref, id) async {
  final items = await ref.watch(announcementsProvider.future);
  for (final item in items) {
    if (item.id == id) return item;
  }
  return null;
});
