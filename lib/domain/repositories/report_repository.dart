import 'package:dartz/dartz.dart';
import '../entities/incident_report.dart';
import '../../core/errors/failures.dart';

abstract class ReportRepository {
  Future<Either<Failure, IncidentReport>> createReport({
    required int userId,
    required String title,
    required String description,
    required String incidentType,
    required double latitude,
    required double longitude,
    String? address,
    String? mediaUrl,
    bool isAnonymous = false,
  });

  Future<Either<Failure, IncidentReport>> getReportById(int id);

  Future<Either<Failure, List<IncidentReport>>> getReportsByUser(int userId);

  Future<Either<Failure, List<IncidentReport>>> getNearbyReports({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  });

  Future<Either<Failure, IncidentReport>> updateReport({
    required int id,
    required String title,
    required String description,
    String? mediaUrl,
  });

  Future<Either<Failure, void>> deleteReport(int id);

  Future<Either<Failure, IncidentReport>> approveReport(int id);

  Future<Either<Failure, IncidentReport>> rejectReport(int id);
}
