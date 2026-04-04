import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../auth/widgets/language_selector.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.profile)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // User header
          user.when(
            data: (u) => Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  backgroundImage:
                      u?.photoUrl != null ? NetworkImage(u!.photoUrl!) : null,
                  child: u?.photoUrl == null
                      ? Text(
                          (u?.displayName ?? '?')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
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
                        u?.displayName ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        u?.email ?? u?.phone ?? '',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 32),

          // Menu items
          _MenuItem(
            icon: Icons.confirmation_num,
            label: l.myBookings,
            onTap: () => context.push('/passes'),
          ),
          _MenuItem(
            icon: Icons.qr_code_2,
            label: l.myPasses,
            onTap: () => context.push('/passes'),
          ),
          _MenuItem(
            icon: Icons.notifications,
            label: l.notifications,
            onTap: () {},
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Language selector
          LanguageSelector(
            currentLanguage:
                user.valueOrNull?.language ?? 'ru',
            onChanged: (lang) async {
              final uid = ref.read(authStateProvider).valueOrNull?.uid;
              if (uid != null) {
                await ref
                    .read(firestoreServiceProvider)
                    .updateUserLanguage(uid, lang);
              }
            },
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          _MenuItem(
            icon: Icons.info_outline,
            label: l.aboutPark,
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.phone,
            label: l.contactUs,
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.description,
            label: l.termsOfService,
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.privacy_tip_outlined,
            label: l.privacyPolicy,
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Logout
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
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(label),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textTertiary,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
