// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ala-Archa';

  @override
  String get welcome => 'Welcome to Ala-Archa';

  @override
  String get welcomeSubtitle => 'Your mountain escape awaits';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get book => 'Book';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get login => 'Log In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithPhone => 'Continue with Phone';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get sendCode => 'Send Code';

  @override
  String get verify => 'Verify';

  @override
  String get logout => 'Log Out';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageKyrgyz => 'Кыргызча';

  @override
  String get parkOpen => 'Park Open';

  @override
  String get parkClosed => 'Park Closed';

  @override
  String trailsStatus(String status) {
    return 'Trails: $status';
  }

  @override
  String get weather => 'Weather';

  @override
  String temperature(String degrees) {
    return '$degrees°C';
  }

  @override
  String get buyPass => 'Buy Park Pass';

  @override
  String get myPasses => 'My Passes';

  @override
  String get dayPass => 'Day Pass';

  @override
  String get multiDayPass => 'Multi-Day Pass';

  @override
  String get annualPass => 'Annual Pass';

  @override
  String get citizen => 'Citizen';

  @override
  String get tourist => 'Tourist';

  @override
  String get child => 'Child';

  @override
  String get student => 'Student';

  @override
  String validUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get showQR => 'Show QR Code';

  @override
  String get passActive => 'Active';

  @override
  String get passUsed => 'Used';

  @override
  String get passExpired => 'Expired';

  @override
  String get accommodations => 'Stays';

  @override
  String get viewAll => 'View All';

  @override
  String get bookNow => 'Book Now';

  @override
  String get perNight => '/ night';

  @override
  String get guests => 'Guests';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String nightCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '1 night',
    );
    return '$_temp0';
  }

  @override
  String get amenities => 'Amenities';

  @override
  String get reviews => 'Reviews';

  @override
  String get includesGondola => 'Includes free gondola access';

  @override
  String get availability => 'Availability';

  @override
  String get selectDates => 'Select Dates';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get bookingConfirmed => 'Booking Confirmed!';

  @override
  String get bookingPending => 'Booking Pending';

  @override
  String get restaurants => 'Dining';

  @override
  String get reserveTable => 'Reserve a Table';

  @override
  String get menu => 'Menu';

  @override
  String get partySize => 'Party Size';

  @override
  String get timeSlot => 'Time Slot';

  @override
  String get specialRequests => 'Special Requests';

  @override
  String get gondola => 'Gondola';

  @override
  String get bookGondola => 'Book Gondola Ride';

  @override
  String get passengers => 'Passengers';

  @override
  String get gondolaOperational => 'Operational';

  @override
  String get gondolaDelayed => 'Delayed';

  @override
  String get gondolaClosed => 'Closed due to weather';

  @override
  String get freeWithStay => 'Free with your stay';

  @override
  String get tours => 'Tours';

  @override
  String get bookTour => 'Book Tour';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get duration => 'Duration';

  @override
  String get maxParticipants => 'Max Participants';

  @override
  String get guide => 'Guide';

  @override
  String hoursCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get trails => 'Trails';

  @override
  String get trailMap => 'Trail Map';

  @override
  String get elevation => 'Elevation';

  @override
  String get distance => 'Distance';

  @override
  String get estimatedTime => 'Estimated Time';

  @override
  String get trailOpen => 'Open';

  @override
  String get trailCaution => 'Caution';

  @override
  String get trailClosed => 'Closed';

  @override
  String get downloadOffline => 'Download for Offline';

  @override
  String get startNavigation => 'Start Navigation';

  @override
  String get sauna => 'Sauna & Wellness';

  @override
  String get bookSession => 'Book Session';

  @override
  String get privateSession => 'Private Session';

  @override
  String get groupSession => 'Group Session';

  @override
  String get sos => 'SOS';

  @override
  String get emergency => 'Emergency';

  @override
  String get sosButton => 'Send Emergency Alert';

  @override
  String get sosConfirm => 'Are you sure you want to send an emergency alert?';

  @override
  String get sosSent => 'Alert sent! Help is on the way.';

  @override
  String get callRangers => 'Call Park Rangers';

  @override
  String get callRescue => 'Call Mountain Rescue';

  @override
  String get aiConcierge => 'Archa AI';

  @override
  String get aiWelcome =>
      'Hi! I\'m Archa, your mountain guide. How can I help you today?';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get uploadReceipt => 'Upload Receipt';

  @override
  String get payment => 'Payment';

  @override
  String get payWithCard => 'Pay with Card';

  @override
  String get payWithMbank => 'Pay with Mbank';

  @override
  String get payWithOdengi => 'Pay with O!Dengi';

  @override
  String get uploadBankReceipt => 'Upload Bank Receipt';

  @override
  String get total => 'Total';

  @override
  String get currency => 'KGS';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get cancelConfirm => 'Are you sure you want to cancel this booking?';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get aboutPark => 'About the Park';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get search => 'Search';

  @override
  String get noResults => 'No results found';

  @override
  String get seeMore => 'See More';
}
