import '../../domain/entities/alert.dart';

class AlertModel {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String message;
  final double? latitude;
  final double? longitude;
  final bool isRead;
  final DateTime createdAt;

  const AlertModel({
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

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      type: json['type'] as String? ??
          json['alert_type'] as String? ??
          '',
      title: json['title'] as String,
      message: json['message'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'latitude': latitude,
      'longitude': longitude,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Alert toEntity() {
    return Alert(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      latitude: latitude,
      longitude: longitude,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
