import '../../domain/entities/location.dart';

class LocationModel {
  final int id;
  final double latitude;
  final double longitude;
  final String? address;
  final String district;
  final int riskLevel;
  final String riskCategory;
  final int incidentCount;
  final String? description;
  final DateTime lastUpdated;

  const LocationModel({
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

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      district: json['district'] as String,
      riskLevel: json['risk_level'] as int,
      riskCategory: json['risk_category'] as String,
      incidentCount: json['incident_count'] as int? ?? 0,
      description: json['description'] as String?,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'district': district,
      'risk_level': riskLevel,
      'risk_category': riskCategory,
      'incident_count': incidentCount,
      'description': description,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  Location toEntity() {
    return Location(
      id: id,
      latitude: latitude,
      longitude: longitude,
      address: address,
      district: district,
      riskLevel: riskLevel,
      riskCategory: riskCategory,
      incidentCount: incidentCount,
      description: description,
      lastUpdated: lastUpdated,
    );
  }
}
