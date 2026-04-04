export type UserRole = 'visitor' | 'admin' | 'staff' | 'guide';
export type Language = 'en' | 'ru' | 'ky';

export interface AppUser {
  uid: string;
  email?: string;
  displayName?: string;
  photoUrl?: string;
  phone?: string;
  role: UserRole;
  language: Language;
  createdAt: Date;
  lastVisit?: Date;
  fcmTokens: string[];
}
