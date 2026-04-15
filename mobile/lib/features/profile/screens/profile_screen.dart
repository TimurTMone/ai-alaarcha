import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/contact_launcher.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../auth/widgets/language_selector.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final user = ref.watch(currentUserProvider).valueOrNull;
    final passes = ref.watch(userPassesProvider).valueOrNull ?? const [];
    final currentLanguage = ref.watch(appLanguageProvider).languageCode;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text(
              l.profile,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 18),
            _ProfileHeroCard(
              userName: user?.displayName,
              subtitle: user?.email ?? user?.phone ?? _guestLabel(locale),
              photoUrl: user?.photoUrl,
              passCount: passes.length,
              locale: locale,
            ),
            const SizedBox(height: 24),
            _SectionTitle(label: _actionsLabel(locale)),
            const SizedBox(height: 12),
            _ActionTile(
              icon: Icons.qr_code_2_rounded,
              label: l.buyPass,
              subtitle: _buyPassSubtitle(locale),
              color: AppColors.primary,
              onTap: () => context.push('/passes/buy'),
            ),
            const SizedBox(height: 12),
            _ActionTile(
              icon: Icons.confirmation_num_rounded,
              label: l.myPasses,
              subtitle: _myPassesSubtitle(locale),
              color: AppColors.accent,
              onTap: () => context.push('/passes'),
            ),
            const SizedBox(height: 12),
            _ActionTile(
              icon: Icons.hotel_rounded,
              label: _staysLabel(locale),
              subtitle: _staysSubtitle(locale),
              color: AppColors.secondaryDark,
              onTap: () => context.go('/accommodations'),
            ),
            const SizedBox(height: 24),
            _SectionTitle(label: _languageLabel(locale)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: LanguageSelector(
                currentLanguage: currentLanguage,
                onChanged: (lang) async {
                  await ref
                      .read(appLanguageProvider.notifier)
                      .setLanguage(lang);
                  final uid = ref.read(authStateProvider).valueOrNull?.uid;
                  if (uid != null) {
                    await ref
                        .read(firestoreServiceProvider)
                        .updateUserLanguage(uid, lang);
                    ref.invalidate(currentUserProvider);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(label: _supportLabel(locale)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ContactTile(
                    icon: Icons.chat_bubble_rounded,
                    label: 'WhatsApp',
                    value: AppConfig.parkPhone,
                    color: const Color(0xFF25D366),
                    onTap: () => ContactLauncher.openWhatsApp(
                      context: context,
                      phoneNumber: AppConfig.parkPhone,
                      message: _supportMessage(locale),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ContactTile(
                    icon: Icons.phone_in_talk_rounded,
                    label: _callLabel(locale),
                    value: AppConfig.parkPhone,
                    color: AppColors.primary,
                    onTap: () =>
                        ContactLauncher.call(context, AppConfig.parkPhone),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _WideInfoCard(
              title: _parkInfoLabel(locale),
              rows: [
                _InfoLine(
                  icon: Icons.email_outlined,
                  text: AppConfig.parkEmail,
                  onTap: () => ContactLauncher.email(
                    context,
                    AppConfig.parkEmail,
                    subject: 'Ala-Archa',
                  ),
                ),
                _InfoLine(
                  icon: Icons.location_on_outlined,
                  text: AppConfig.parkAddress,
                ),
                _InfoLine(
                  icon: Icons.schedule_rounded,
                  text: AppConfig.parkHours,
                ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => ref.read(authServiceProvider).signOut(),
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(
                l.logout,
                style: const TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.userName,
    required this.subtitle,
    required this.photoUrl,
    required this.passCount,
    required this.locale,
  });

  final String? userName;
  final String subtitle;
  final String? photoUrl;
  final int passCount;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final initialsSource = userName?.trim().isNotEmpty == true
        ? userName!
        : '?';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                backgroundImage: photoUrl != null
                    ? NetworkImage(photoUrl!)
                    : null,
                child: photoUrl == null
                    ? Text(
                        initialsSource[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName?.trim().isNotEmpty == true
                          ? userName!
                          : _guestLabel(locale),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: _passesLabel(locale),
                  value: '$passCount',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroStat(
                  label: _languageShortLabel(locale),
                  value: locale.toUpperCase(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WideInfoCard extends StatelessWidget {
  const _WideInfoCard({required this.title, required this.rows});

  final String title;
  final List<_InfoLine> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          for (final row in rows) ...[row, const SizedBox(height: 14)],
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text, this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: content,
    );
  }
}

String _guestLabel(String locale) =>
    {'en': 'Guest', 'ru': 'Гость', 'ky': 'Конок'}[locale] ?? 'Гость';

String _actionsLabel(String locale) =>
    {
      'en': 'Quick actions',
      'ru': 'Быстрые действия',
      'ky': 'Тез аракеттер',
    }[locale] ??
    'Быстрые действия';

String _buyPassSubtitle(String locale) =>
    {
      'en': 'Buy entry QR for the park',
      'ru': 'Купить входной QR в парк',
      'ky': 'Паркка кирүү QR кодун алуу',
    }[locale] ??
    'Купить входной QR в парк';

String _myPassesSubtitle(String locale) =>
    {
      'en': 'Check current and used passes',
      'ru': 'Проверить активные и использованные пропуска',
      'ky': 'Активдүү жана колдонулган пропусктарды көрүү',
    }[locale] ??
    'Проверить активные и использованные пропуска';

String _staysLabel(String locale) =>
    {'en': 'Stays', 'ru': 'Проживание', 'ky': 'Жашоо жайы'}[locale] ??
    'Проживание';

String _staysSubtitle(String locale) =>
    {
      'en': 'Open hotels and cabins',
      'ru': 'Открыть отели и домики',
      'ky': 'Мейманканаларды жана үйлөрдү ачуу',
    }[locale] ??
    'Открыть отели и домики';

String _languageLabel(String locale) =>
    {
      'en': 'Language',
      'ru': 'Язык приложения',
      'ky': 'Колдонмо тили',
    }[locale] ??
    'Язык приложения';

String _supportLabel(String locale) =>
    {
      'en': 'Support and contacts',
      'ru': 'Поддержка и контакты',
      'ky': 'Колдоо жана байланыш',
    }[locale] ??
    'Поддержка и контакты';

String _supportMessage(String locale) =>
    {
      'en': 'Hello! I need help with Ala-Archa app.',
      'ru': 'Здравствуйте! Нужна помощь по приложению Ala-Archa.',
      'ky': 'Салам! Ala-Archa тиркемеси боюнча жардам керек.',
    }[locale] ??
    'Здравствуйте! Нужна помощь по приложению Ala-Archa.';

String _callLabel(String locale) =>
    {'en': 'Call', 'ru': 'Позвонить', 'ky': 'Чалуу'}[locale] ?? 'Позвонить';

String _parkInfoLabel(String locale) =>
    {
      'en': 'Park information',
      'ru': 'Информация о парке',
      'ky': 'Парк тууралуу маалымат',
    }[locale] ??
    'Информация о парке';

String _passesLabel(String locale) =>
    {'en': 'Passes', 'ru': 'Пропуска', 'ky': 'Пропусктар'}[locale] ??
    'Пропуска';

String _languageShortLabel(String locale) =>
    {'en': 'Language', 'ru': 'Язык', 'ky': 'Тил'}[locale] ?? 'Язык';
