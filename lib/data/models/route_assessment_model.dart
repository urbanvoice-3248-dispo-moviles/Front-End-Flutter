import '../../domain/entities/route_assessment.dart';

class WaypointDto {
  final double lat;
  final double lng;

  const WaypointDto({required this.lat, required this.lng});

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class RouteAssessmentRequestDto {
  final List<WaypointDto> waypoints;

  const RouteAssessmentRequestDto({required this.waypoints});

  Map<String, dynamic> toJson() =>
      {'waypoints': waypoints.map((w) => w.toJson()).toList()};
}

class SegmentAssessmentDto {
  final int index;
  final String district;
  final int riskLevel;
  final String riskCategory;

  const SegmentAssessmentDto({
    required this.index,
    required this.district,
    required this.riskLevel,
    required this.riskCategory,
  });

  factory SegmentAssessmentDto.fromJson(Map<String, dynamic> json) {
    return SegmentAssessmentDto(
      index: json['index'] as int,
      district: json['district'] as String,
      riskLevel: json['risk_level'] as int,
      riskCategory: json['risk_category'] as String,
    );
  }

  SegmentAssessment toEntity() => SegmentAssessment(
        index: index,
        district: district,
        riskLevel: riskLevel,
        riskCategory: riskCategory,
      );
}

class RouteAssessmentResponseDto {
  final List<SegmentAssessmentDto> segments;
  final double overallSafetyScore;

  const RouteAssessmentResponseDto({
    required this.segments,
    required this.overallSafetyScore,
  });

  factory RouteAssessmentResponseDto.fromJson(Map<String, dynamic> json) {
    return RouteAssessmentResponseDto(
      segments: (json['segments'] as List)
          .map((e) => SegmentAssessmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallSafetyScore: (json['overall_safety_score'] as num).toDouble(),
    );
  }

  RouteAssessment toEntity() => RouteAssessment(
        segments: segments.map((s) => s.toEntity()).toList(),
        overallSafetyScore: overallSafetyScore,
      );
}
