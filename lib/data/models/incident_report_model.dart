import '../../domain/entities/incident_report.dart';

class IncidentReportModel {
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

  const IncidentReportModel({
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

  factory IncidentReportModel.fromJson(Map<String, dynamic> json) {
    return IncidentReportModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      incidentType: json['incident_type'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      mediaUrl: json['media_url'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      reportedAt: DateTime.parse(json['reported_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'incident_type': incidentType,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'media_url': mediaUrl,
      'is_anonymous': isAnonymous,
      'reported_at': reportedAt.toIso8601String(),
    };
  }

  IncidentReport toEntity() {
    return IncidentReport(
      id: id,
      userId: userId,
      title: title,
      description: description,
      incidentType: incidentType,
      latitude: latitude,
      longitude: longitude,
      address: address,
      mediaUrl: mediaUrl,
      isAnonymous: isAnonymous,
      reportedAt: reportedAt,
    );
  }
}

class CreateReportRequest {
  final String title;
  final String description;
  final String incidentType;
  final double latitude;
  final double longitude;
  final String? address;
  final String? mediaUrl;
  final bool isAnonymous;

  const CreateReportRequest({
    required this.title,
    required this.description,
    required this.incidentType,
    required this.latitude,
    required this.longitude,
    this.address,
    this.mediaUrl,
    this.isAnonymous = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'incident_type': incidentType,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'media_url': mediaUrl,
      'is_anonymous': isAnonymous,
    };
  }
}

class UpdateReportRequest {
  final String title;
  final String description;
  final String? mediaUrl;

  const UpdateReportRequest({
    required this.title,
    required this.description,
    this.mediaUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'media_url': mediaUrl,
    };
  }
}
