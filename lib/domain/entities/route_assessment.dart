import 'package:equatable/equatable.dart';

class SegmentAssessment extends Equatable {
  final int index;
  final String district;
  final int riskLevel;
  final String riskCategory;

  const SegmentAssessment({
    required this.index,
    required this.district,
    required this.riskLevel,
    required this.riskCategory,
  });

  @override
  List<Object?> get props => [index, district, riskLevel, riskCategory];
}

class RouteAssessment extends Equatable {
  final List<SegmentAssessment> segments;
  final double overallSafetyScore;

  const RouteAssessment({
    required this.segments,
    required this.overallSafetyScore,
  });

  @override
  List<Object?> get props => [segments, overallSafetyScore];
}
