import 'package:equatable/equatable.dart';

/// Zona georreferenciada con informacion agregada de riesgo ciudadano.
///
/// Representa puntos o distritos que el mapa puede mostrar junto con su nivel
/// de riesgo e historial de incidentes.
class Location extends Equatable {
  /// Identificador unico de la ubicacion.
  final int id;

  /// Coordenadas geograficas usadas para posicionar el marcador en el mapa.
  final double latitude;
  final double longitude;

  /// Direccion textual opcional cuando el backend la entrega.
  final String? address;

  /// Distrito al que pertenece la ubicacion.
  final String district;

  /// Nivel numerico de riesgo. Los valores mas altos indican mayor peligro.
  final int riskLevel;

  /// Categoria legible del nivel de riesgo.
  final String riskCategory;

  /// Cantidad de incidentes asociados a la ubicacion.
  final int incidentCount;

  /// Descripcion opcional de la zona o del patron de riesgo.
  final String? description;

  /// Ultima fecha de actualizacion de la informacion de riesgo.
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
