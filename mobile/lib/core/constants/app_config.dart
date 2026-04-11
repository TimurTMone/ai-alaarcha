/// App-wide configuration flags.
abstract final class AppConfig {
  /// When true: bypasses Firebase auth, uses in-memory mock data, and tolerates
  /// Firebase init failures. Set to false before shipping to TestFlight.
  static const bool devMode = true;
  static const bool useBackendContent = true;
  static const bool useBackendBookings = true;
  static const String backendBaseUrl =
      'https://alarcha-backend-06ce07320e64.herokuapp.com/api';

  /// Bank details shown on the payment instructions screen. Users transfer to
  /// this account and paste the booking shortRef into the memo. Replace with
  /// real park account before launch.
  static const String bankName = 'MBank';
  static const String bankAccount = '4177 49 00 0000 0000';
  static const String bankRecipient = 'Ala-Archa National Park';
  static const String bankBik = '114001';

  // ── Park contact info (from alaarchapark.com/contacts) ──────────────
  static const String parkPhone = '+996 777 212 798';
  static const String parkEmail = 'alaarca555@gmail.com';
  static const String checkpointPhone = '+996 312 883 205';
  static const String parkAddress =
      'Kyrgyz Republic, Chui region, Alamudun district, Kashka-Suu village';
  static const String parkHours = '09:00–17:30 (Mon–Fri)';

  // Accommodation direct phones
  static const String hotelAlaArchaPhone = '+996 701 551 026';
  static const String aframeCottagesPhone = '+996 550 133 603';
  static const String hotelAkmaralPhone = '+996 505 960 097';
  static const String hotelAkBataPhone = '+996 500 417 741';
  static const String cafePhone = '+996 702 150 976';
  static const String saunaPhone = '+996 999 380 280';

  // ── Gondola (Doppelmayr, opened Feb 2026) ──────────────────────────
  // 1 km, 2166 m → 2494 m, 16 cabins (10-seat std + 2 VIP 4-seat)
  // Up to 1,000 pax/hour. Cashless only. Closed Mondays.
  // Hours: 10:00–19:00. Round trip: 600 KGS adult, 400 KGS child.
  // Guests of Khan-Teniri barnhouses ride free.

  // ── Khan-Teniri (private operator inside park) ─────────────────────
  // 21 modern cottages with sauna & jacuzzi at lower station.
  // 20 A-frame houses planned at upper station.
  // 5-star hotel under construction (target: end of summer 2026).
  // Glass terrace photo zone planned.
  // Barnhouse rate: $250/night (reduced from $350, Mar 2026).
  // Director: Bakyt Ibraimov.

  // ── Park rules (since May 2025) ────────────────────────────────────
  // Gas/diesel/LPG vehicles PROHIBITED inside park.
  // 2,500-space parking at entrance. Electric scooter & bike rental at checkpoint.
  // Electric vehicle entry: 800 KGS.
  // Adults: 200 KGS, Children 7-14: 150 KGS.
}
