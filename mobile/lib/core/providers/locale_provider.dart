import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _languageStorageKey = 'app_language';
const _supportedLanguageCodes = {'ru', 'en', 'ky'};

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences provider must be overridden.');
});

final appLanguageProvider =
    StateNotifierProvider<AppLanguageController, Locale>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      final savedCode = prefs.getString(_languageStorageKey) ?? 'ru';
      return AppLanguageController(prefs, savedCode);
    });

class AppLanguageController extends StateNotifier<Locale> {
  AppLanguageController(this._prefs, String initialLanguageCode)
    : super(Locale(_normalize(initialLanguageCode)));

  final SharedPreferences _prefs;

  String get languageCode => state.languageCode;

  Future<void> setLanguage(String languageCode) async {
    final normalizedCode = _normalize(languageCode);
    if (state.languageCode == normalizedCode) return;
    state = Locale(normalizedCode);
    await _prefs.setString(_languageStorageKey, normalizedCode);
  }

  Future<void> syncFromUser(String? languageCode) async {
    if (languageCode == null || languageCode.trim().isEmpty) return;
    final normalizedCode = _normalize(languageCode);
    if (state.languageCode == normalizedCode) return;
    state = Locale(normalizedCode);
    await _prefs.setString(_languageStorageKey, normalizedCode);
  }

  static String _normalize(String languageCode) {
    final normalizedCode = languageCode.toLowerCase().trim();
    if (_supportedLanguageCodes.contains(normalizedCode)) {
      return normalizedCode;
    }
    return 'ru';
  }
}
