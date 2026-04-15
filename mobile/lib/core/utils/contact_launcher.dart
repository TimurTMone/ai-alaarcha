import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class ContactLauncher {
  static Future<bool> openWhatsApp({
    required BuildContext context,
    required String phoneNumber,
    required String message,
  }) async {
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse(
      'https://wa.me/$digits?text=${Uri.encodeComponent(message)}',
    );
    return _launch(context, uri);
  }

  static Future<bool> call(BuildContext context, String phoneNumber) async {
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: digits);
    return _launch(context, uri);
  }

  static Future<bool> email(
    BuildContext context,
    String email, {
    String? subject,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: subject == null ? null : {'subject': subject},
    );
    return _launch(context, uri);
  }

  static Future<bool> _launch(BuildContext context, Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorLabel(context))));
    }
    return launched;
  }

  static String _errorLabel(BuildContext context) {
    return switch (Localizations.localeOf(context).languageCode) {
      'en' => 'Could not open the selected app.',
      'ky' => 'Тандалган тиркеме ачылган жок.',
      _ => 'Не удалось открыть выбранное приложение.',
    };
  }
}
