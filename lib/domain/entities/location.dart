import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa una ubicación dentro de UrbanVoice.
///
/// Incluye sus coordenadas, el distrito, el nivel de riesgo calculado y el
/// número de incidentes asociados. Extiende [Equatable] para poder
/// compararse por valor.
class Location extends Equatable {
  /// Identificador único de la ubicación.
  final int id;

  /// Latitud geográfica en grados decimales.
  final double latitude;

  /// Longitud geográfica en grados decimales.
  final double longitude;

  /// Dirección textual opcional.
  final String? address;

  /// Distrito al que pertenece la ubicación.
  final String district;

  /// Nivel de riesgo numérico asociado a la zona.
  final int riskLevel;

  /// Categoría de riesgo legible (por ejemplo, "alto", "medio").
  final String riskCategory;

  /// Cantidad de incidentes reportados en la ubicación.
  final int incidentCount;

  /// Descripción opcional de la ubicación.
  final String? description;

  /// Fecha de la última actualización de los datos.
  final DateTime lastUpdated;

  const Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.district,
    required this.riskLevel,
    required this.riskCategory,
    required this.incidentCount,
    this.description,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        id,
        latitude,
        longitude,
        address,
        district,
        riskLevel,
        riskCategory,
        incidentCount,
        description,
        lastUpdated,
      ];
}
