import 'package:dartz/dartz.dart';
import '../entities/incident_report.dart';
import '../repositories/report_repository.dart';
import '../../core/errors/failures.dart';

class CreateReport {
  final ReportRepository repository;

  CreateReport(this.repository);

  Future<Either<Failure, IncidentReport>> call({
    required int userId,
    required String title,
    required String description,
    required String incidentType,
    required double latitude,
    required double longitude,
    String? address,
    String? mediaUrl,
    bool isAnonymous = false,
  }) {
    return repository.createReport(
      userId: userId,
      title: title,
      description: description,
      incidentType: incidentType,
      latitude: latitude,
      longitude: longitude,
      address: address,
      mediaUrl: mediaUrl,
      isAnonymous: isAnonymous,
    );
  }
}

class GetReportById {
  final ReportRepository repository;

  GetReportById(this.repository);

  Future<Either<Failure, IncidentReport>> call(int id) {
    return repository.getReportById(id);
  }
}

class GetReportsByUser {
  final ReportRepository repository;

  GetReportsByUser(this.repository);

  Future<Either<Failure, List<IncidentReport>>> call(int userId) {
    return repository.getReportsByUser(userId);
  }
}

class GetNearbyReports {
  final ReportRepository repository;

  GetNearbyReports(this.repository);

  Future<Either<Failure, List<IncidentReport>>> call({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  }) {
    return repository.getNearbyReports(
      latitude: latitude,
      longitude: longitude,
      radiusInKm: radiusInKm,
    );
  }
}

class DeleteReport {
  final ReportRepository repository;

  DeleteReport(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteReport(id);
  }
}

class ApproveReport {
  final ReportRepository repository;

  ApproveReport(this.repository);

  Future<Either<Failure, IncidentReport>> call(int id) {
    return repository.approveReport(id);
  }
}

class RejectReport {
  final ReportRepository repository;

  RejectReport(this.repository);

  Future<Either<Failure, IncidentReport>> call(int id) {
    return repository.rejectReport(id);
  }
}
