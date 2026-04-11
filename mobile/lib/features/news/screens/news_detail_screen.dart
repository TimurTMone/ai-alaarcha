import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/providers/news_provider.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final String newsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final newsAsync = ref.watch(announcementByIdProvider(newsId));

    return Scaffold(
      body: newsAsync.when(
        data: (news) {
          if (news == null) {
            return const Center(child: Text('News not found'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    news.localizedTitle(locale),
                    maxLines: 2,
                    style: const TextStyle(fontSize: 16),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (news.imageUrl != null)
                        Image.network(
                          news.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imagePlaceholder(),
                        )
                      else
                        _imagePlaceholder(),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.65),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.categoryName?.isNotEmpty == true) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            news.categoryName!,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        _formatDate(news.createdAt),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (news.localizedBody(locale).isNotEmpty) ...[
                        Text(
                          news.localizedBody(locale),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        news.localizedContent(locale),
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  static Widget _imagePlaceholder() => Container(
        color: AppColors.primary.withValues(alpha: 0.08),
        child: const Center(
          child: Icon(
            Icons.newspaper,
            size: 72,
            color: AppColors.primary,
          ),
        ),
      );

  static String _formatDate(DateTime d) =>
      '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
