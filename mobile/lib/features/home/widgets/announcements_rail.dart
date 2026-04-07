import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/models/announcement_model.dart';

final announcementsProvider = StreamProvider<List<Announcement>>((ref) {
  if (AppConfig.devMode) return Stream.value(const []);
  return FirebaseFirestore.instance
      .collection('announcements')
      .orderBy('createdAt', descending: true)
      .limit(10)
      .snapshots()
      .map((snap) => snap.docs
          .map(Announcement.fromFirestore)
          .where((a) => !a.isExpired)
          .toList());
});

class AnnouncementsRail extends ConsumerWidget {
  const AnnouncementsRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final asyncAnnouncements = ref.watch(announcementsProvider);

    return asyncAnnouncements.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (announcements) {
        if (announcements.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  const Icon(Icons.campaign, size: 20, color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    _title(locale),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: announcements.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) =>
                    _AnnouncementCard(announcement: announcements[i], locale: locale),
              ),
            ),
          ],
        );
      },
    );
  }

  static String _title(String l) =>
      {'en': 'News', 'ru': 'Новости', 'ky': 'Жаңылыктар'}[l] ?? 'Новости';
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement, required this.locale});
  final Announcement announcement;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          if (announcement.imageUrl != null)
            Image.network(
              announcement.imageUrl!,
              width: 90,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 90,
                color: AppColors.secondary.withValues(alpha: 0.12),
                child: const Icon(Icons.image, color: AppColors.secondary),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.localizedTitle(locale),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (announcement.localizedBody(locale).isNotEmpty)
                    Text(
                      announcement.localizedBody(locale),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  const Spacer(),
                  Text(
                    _formatDate(announcement.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) =>
      '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
