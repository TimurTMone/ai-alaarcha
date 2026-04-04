abstract final class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const onboarding = '/onboarding';

  // Passes
  static const buyPass = '/passes/buy';
  static const myPasses = '/passes';
  static const passQR = '/passes/:passId/qr';

  // Accommodations
  static const accommodations = '/accommodations';
  static const accommodationDetail = '/accommodations/:id';
  static const accommodationBooking = '/accommodations/:id/book';

  // AI Concierge
  static const chat = '/chat';

  // Restaurant
  static const restaurants = '/restaurants';
  static const restaurantDetail = '/restaurants/:id';
  static const reservation = '/restaurants/:id/reserve';

  // Gondola
  static const gondola = '/gondola';
  static const gondolaBooking = '/gondola/book';

  // Tours
  static const tours = '/tours';
  static const tourDetail = '/tours/:id';
  static const tourBooking = '/tours/:id/book';

  // Trails
  static const trails = '/trails';
  static const trailDetail = '/trails/:id';

  // Sauna
  static const sauna = '/sauna';

  // SOS
  static const sos = '/sos';

  // Profile
  static const profile = '/profile';
  static const bookingHistory = '/profile/bookings';
  static const settings = '/profile/settings';

  // Notifications
  static const notifications = '/notifications';
}
