import '../../domain/entities/alert_config.dart';

class AlertConfigModel {
  final int id;
  final int userId;
  final bool enabled;
  final double radiusInKm;
  final bool notifyByEmail;

  const AlertConfigModel({
    required this.id,
    required this.userId,
    required this.enabled,
    required this.radiusInKm,
    required this.notifyByEmail,
  });

  factory AlertConfigModel.fromJson(Map<String, dynamic> json) {
    return AlertConfigModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      enabled: json['enabled'] as bool? ?? true,
      radiusInKm: (json['radius_in_km'] as num?)?.toDouble() ?? 0.0,
      notifyByEmail: json['notify_by_email'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'enabled': enabled,
        'radius_in_km': radiusInKm,
        'notify_by_email': notifyByEmail,
      };

  AlertConfig toEntity() => AlertConfig(
        id: id,
        userId: userId,
        enabled: enabled,
        radiusInKm: radiusInKm,
        notifyByEmail: notifyByEmail,
      );
}

class UpdateAlertConfigRequest {
  final bool? enabled;
  final double? radiusInKm;
  final bool? notifyByEmail;

  const UpdateAlertConfigRequest({this.enabled, this.radiusInKm, this.notifyByEmail});

  Map<String, dynamic> toJson() => {
        if (enabled != null) 'enabled': enabled,
        if (radiusInKm != null) 'radius_in_km': radiusInKm,
        if (notifyByEmail != null) 'notify_by_email': notifyByEmail,
      };
}
