/// Constantes generales de la aplicación UrbanVoice.
///
/// Agrupa valores por defecto que no dependen del entorno de red, como el
/// radio de búsqueda o la posición inicial del mapa.
class AppConstants {
  /// Nombre público de la aplicación.
  static const String appName = 'UrbanVoice';

  /// Radio de búsqueda por defecto, en kilómetros.
  static const double defaultRadiusKm = 5.0;

  /// Tamaño máximo permitido para el contenido multimedia, en megabytes.
  static const int maxMediaSizeMb = 10;

  /// Latitud inicial del mapa (centro de Lima por defecto).
  static const double mapDefaultLatitude = -12.0464;

  /// Longitud inicial del mapa (centro de Lima por defecto).
  static const double mapDefaultLongitude = -77.0428;

  /// Nivel de zoom inicial del mapa.
  static const String mapDefaultZoom = '12.0';
}
