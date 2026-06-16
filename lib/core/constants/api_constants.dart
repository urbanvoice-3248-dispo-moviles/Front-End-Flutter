import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return 'http://localhost:8080/api/v1';
    }
    return 'http://10.0.2.2:8080/api/v1';
  }

  static const String profiles = '/profiles';
  static const String profilesByEmail = '/profiles/email';
  static const String reports = '/reports';
  static const String reportsNearby = '/reports/nearby';
  static const String reportsByUser = '/reports/user';
  static const String locations = '/locations';
  static const String locationsNearby = '/locations/nearby';
  static const String locationsByDistrict = '/locations/district';
  static const String locationsDangerous = '/locations/dangerous';
  static const String alerts = '/alerts';
  static const String alertsByUser = '/alerts/user';
}
