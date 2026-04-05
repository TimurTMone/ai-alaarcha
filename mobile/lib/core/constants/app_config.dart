/// App-wide configuration flags.
abstract final class AppConfig {
  /// When true: bypasses Firebase auth, uses in-memory mock data, and tolerates
  /// Firebase init failures. Set to false before shipping to TestFlight.
  static const bool devMode = true;

  /// Bank details shown on the payment instructions screen. Users transfer to
  /// this account and paste the booking shortRef into the memo. Replace with
  /// real park account before launch.
  static const String bankName = 'MBank';
  static const String bankAccount = '4177 49 00 0000 0000';
  static const String bankRecipient = 'Ala-Archa National Park';
  static const String bankBik = '114001';
}
