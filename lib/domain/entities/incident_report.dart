import 'package:equatable/equatable.dart';

class IncidentReport extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String incidentType;
  final double latitude;
  final double longitude;
  final String? address;
  final String? mediaUrl;
  final bool isAnonymous;
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
