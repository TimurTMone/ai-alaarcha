import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

class AlaArchaApp extends ConsumerWidget {
  const AlaArchaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(appLanguageProvider);

    // Kick off FCM init once auth resolves (no-op in devMode).
    ref.watch(fcmInitProvider);
    ref.listen(currentUserProvider, (previous, next) {
      final userLanguage = next.valueOrNull?.language;
      if (userLanguage == null) return;
      ref.read(appLanguageProvider.notifier).syncFromUser(userLanguage);
    });

    return MaterialApp.router(
      title: 'Ala-Archa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
    );
  }
}
