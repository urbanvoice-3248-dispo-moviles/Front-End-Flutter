import 'package:equatable/equatable.dart';

class ReportStatistics extends Equatable {
  final int totalReports;
  final Map<String, int> reportsByType;
  final Map<String, int> reportsByStatus;

  const ReportStatistics({
    required this.totalReports,
    required this.reportsByType,
    required this.reportsByStatus,
  });

  @override
  List<Object?> get props => [totalReports, reportsByType, reportsByStatus];
}
