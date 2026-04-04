/// Resolves a locale map to a single string.
/// Fallback chain: requested → ru → en → empty.
String localized(Map<String, String> field, String locale) {
  return field[locale] ?? field['ru'] ?? field['en'] ?? '';
}
