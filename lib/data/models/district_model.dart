import '../../domain/entities/district.dart';

class BoundaryPointDto {
  final double latitude;
  final double longitude;

  const BoundaryPointDto({required this.latitude, required this.longitude});

  factory BoundaryPointDto.fromJson(Map<String, dynamic> json) {
    return BoundaryPointDto(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'latitude': latitude, 'longitude': longitude};

  GeoPoint toEntity() => GeoPoint(latitude: latitude, longitude: longitude);
}

class DistrictModel {
  final int id;
  final String name;
  final int riskLevel;
  final String riskCategory;
  final String? riskDescription;
  final List<BoundaryPointDto> boundary;
  final String? description;
  final int incidentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DistrictModel({
    required this.id,
    required this.name,
    required this.riskLevel,
    required this.riskCategory,
    this.riskDescription,
    required this.boundary,
    this.description,
    required this.incidentCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] as int,
      name: json['name'] as String,
      riskLevel: json['risk_level'] as int,
      riskCategory: json['risk_category'] as String,
      riskDescription: json['risk_description'] as String?,
      boundary: (json['boundary'] as List)
          .map((e) => BoundaryPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      incidentCount: json['incident_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'risk_level': riskLevel,
        'risk_category': riskCategory,
        'risk_description': riskDescription,
        'boundary': boundary.map((e) => e.toJson()).toList(),
        'description': description,
        'incident_count': incidentCount,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  District toEntity() => District(
        id: id,
        name: name,
        riskLevel: riskLevel,
        riskCategory: riskCategory,
        riskDescription: riskDescription,
        boundary: boundary.map((e) => e.toEntity()).toList(),
        description: description,
        incidentCount: incidentCount,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
