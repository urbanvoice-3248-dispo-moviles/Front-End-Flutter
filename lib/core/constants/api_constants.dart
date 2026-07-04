class ApiConstants {
  // Local (para pruebas):
  // static const String baseUrl = 'http://localhost:8080/api/v1';
  // static const String baseUrlAndroid = 'http://10.0.2.2:8080/api/v1';
  static const String baseUrl = 'https://backend-urbanvoice.onrender.com/api/v1';

  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profiles = '/profiles';
  static const String profilesByEmail = '/profiles/email';
  static const String reports = '/reports';
  static const String reportsNearby = '/reports/nearby';
  static const String reportsByUser = '/reports/user';
  static const String reportsAll = '/reports/all';
  static const String reportsStatistics = '/reports/statistics';
  static const String locations = '/locations';
  static const String locationsNearby = '/locations/nearby';
  static const String locationsByDistrict = '/locations/district';
  static const String locationsDangerous = '/locations/dangerous';
  static const String districts = '/districts';
  static const String districtsDangerous = '/districts/dangerous';
  static const String alerts = '/alerts';
  static const String alertsByUser = '/alerts/user';
  static const String alertConfig = '/alert-config/user';
  static const String votes = '/votes';
  static const String categories = '/categories';
  static const String routesAssess = '/routes/assess';
  static const String locationSharingPublish = '/location-sharing/publish';
  static const String locationSharingShare = '/location-sharing/share';
  static const String locationSharingShares = '/location-sharing/shares';
  static const String locationSharingSharedWithMe = '/location-sharing/shared-with-me';
  static const String locationSharingFriends = '/location-sharing/friends';
  static const String locationSharingMe = '/location-sharing/me';
}
