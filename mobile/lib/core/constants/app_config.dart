/// App-wide configuration flags.
abstract final class AppConfig {
  /// When true: bypasses Firebase auth, uses in-memory mock data, and tolerates
  /// Firebase init failures. Set to false before shipping to TestFlight.
  static const bool devMode = true;
}
