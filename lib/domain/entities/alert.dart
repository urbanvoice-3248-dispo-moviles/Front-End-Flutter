import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa una alerta/notificación mostrada al
/// usuario.
///
/// Puede incluir una posición geográfica opcional cuando la alerta está
/// asociada a un lugar concreto.
class Alert extends Equatable {
  /// Identificador único de la alerta.
  final int id;

  /// Identificador del usuario destinatario.
  final int userId;

  /// Tipo de alerta (por ejemplo, emergencia o informativa).
  final String type;

  /// Título breve de la alerta.
  final String title;

  /// Cuerpo del mensaje de la alerta.
  final String message;

  /// Latitud asociada a la alerta, si aplica.
  final double? latitude;

  /// Longitud asociada a la alerta, si aplica.
  final double? longitude;

  /// Indica si el usuario ya leyó la alerta.
  final bool isRead;

  /// Fecha de creación de la alerta.
  final DateTime createdAt;

  const Alert({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.latitude,
    this.longitude,
    required this.isRead,
    required this.createdAt,
  });

  /// Devuelve una copia de la alerta permitiendo actualizar [isRead].
  Alert copyWith({bool? isRead}) {
    return Alert(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      latitude: latitude,
      longitude: longitude,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        message,
        latitude,
        longitude,
        isRead,
        createdAt,
      ];
}
