import 'package:equatable/equatable.dart';

class Alert extends Equatable {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String message;
  final double? latitude;
  final double? longitude;
  final bool isRead;
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
