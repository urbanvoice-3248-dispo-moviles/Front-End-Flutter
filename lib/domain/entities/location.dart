import 'package:equatable/equatable.dart';

class Location extends Equatable {
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

  const Location({
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

  @override
  List<Object?> get props => [
        id,
        latitude,
        longitude,
        address,
        district,
        riskLevel,
        riskCategory,
        incidentCount,
        description,
        lastUpdated,
      ];
}
