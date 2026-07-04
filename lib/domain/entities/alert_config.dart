import 'package:equatable/equatable.dart';

class AlertConfig extends Equatable {
  final int id;
  final int userId;
  final bool enabled;
  final double radiusInKm;
  final bool notifyByEmail;

  const AlertConfig({
    required this.id,
    required this.userId,
    required this.enabled,
    required this.radiusInKm,
    required this.notifyByEmail,
  });

  @override
  List<Object?> get props => [id, userId, enabled, radiusInKm, notifyByEmail];
}
