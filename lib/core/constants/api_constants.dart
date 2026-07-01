import 'package:flutter/foundation.dart';

/// Constantes relacionadas con la API REST del backend de UrbanVoice.
///
/// Centraliza la URL base (que varía según la plataforma) y las rutas
/// relativas de cada recurso, evitando cadenas mágicas repartidas por el
/// código.
class ApiConstants {
  /// URL base de la API según la plataforma de ejecución.
  ///
  /// En el emulador de Android se usa `10.0.2.2` para alcanzar el host;
  /// en web y escritorio se usa `localhost`.
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
