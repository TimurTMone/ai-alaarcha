export type LocaleMap = {
  en?: string;
  ru?: string;
  ky?: string;
};

export function localized(field: LocaleMap, locale: string): string {
  return (
    (field as Record<string, string>)[locale] ??
    field.ru ??
    field.en ??
    ''
  );
}
