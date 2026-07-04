import 'package:equatable/equatable.dart';

class GeoPoint extends Equatable {
  final double latitude;
  final double longitude;

  const GeoPoint({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class District extends Equatable {
  final int id;
  final String name;
  final int riskLevel;
  final String riskCategory;
  final String? riskDescription;
  final List<GeoPoint> boundary;
  final String? description;
  final int incidentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const District({
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

  @override
  List<Object?> get props => [
        id,
        name,
        riskLevel,
        riskCategory,
        riskDescription,
        boundary,
        description,
        incidentCount,
        createdAt,
        updatedAt,
      ];
}
