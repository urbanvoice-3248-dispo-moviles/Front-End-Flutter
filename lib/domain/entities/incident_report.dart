import 'package:equatable/equatable.dart';

/// Reporte ciudadano de un incidente registrado en una ubicacion del mapa.
///
/// La entidad se mantiene libre de detalles de infraestructura para poder
/// reutilizarla desde casos de uso, BLoCs y vistas sin depender de la API.
class IncidentReport extends Equatable {
  /// Identificador unico del reporte.
  final int id;

  /// Usuario que creo el reporte.
  final int userId;

  /// Titulo breve visible en listados y ventanas del mapa.
  final String title;

  /// Descripcion completa del incidente reportado.
  final String description;

  /// Tipo de incidente usado para clasificar y pintar marcadores.
  final String incidentType;

  /// Coordenadas geograficas donde ocurrio el incidente.
  final double latitude;
  final double longitude;

  /// Direccion textual opcional asociada al punto reportado.
  final String? address;

  /// Recurso multimedia opcional adjunto al reporte.
  final String? mediaUrl;

  /// Indica si la identidad del usuario debe ocultarse en la presentacion.
  final bool isAnonymous;

  /// Fecha y hora en que se registro el reporte.
  final DateTime reportedAt;

  const IncidentReport({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.incidentType,
    required this.latitude,
    required this.longitude,
    this.address,
    this.mediaUrl,
    required this.isAnonymous,
    required this.reportedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        incidentType,
        latitude,
        longitude,
        address,
        mediaUrl,
        isAnonymous,
        reportedAt,
      ];
}
