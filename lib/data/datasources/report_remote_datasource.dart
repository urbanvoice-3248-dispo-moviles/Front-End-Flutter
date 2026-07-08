import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/incident_report_model.dart';

class ReportRemoteDataSource {
  final ApiClient _client;

  ReportRemoteDataSource(this._client);

  Future<IncidentReportModel> createReport(
      Map<String, dynamic> data, int userId) async {
    final response = await _client.post(
      ApiConstants.reports,
      data: data,
      headers: {'X-User-ID': userId.toString()},
    );
    return IncidentReportModel.fromJson(response.data);
  }

  Future<IncidentReportModel> getReportById(int id) async {
    final response = await _client.get('${ApiConstants.reports}/$id');
    return IncidentReportModel.fromJson(response.data);
  }

  Future<List<IncidentReportModel>> getReportsByUser(int userId) async {
    final response =
        await _client.get('${ApiConstants.reportsByUser}/$userId');
    return (response.data as List)
        .map((e) => IncidentReportModel.fromJson(e))
        .toList();
  }

  Future<List<IncidentReportModel>> getNearbyReports(
      double latitude, double longitude, double radiusInKm) async {
    final response = await _client.get(
      ApiConstants.reportsNearby,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radiusInKm': radiusInKm,
      },
    );
    return (response.data as List)
        .map((e) => IncidentReportModel.fromJson(e))
        .toList();
  }

  Future<IncidentReportModel> updateReport(
      int id, Map<String, dynamic> data) async {
    final response =
        await _client.put('${ApiConstants.reports}/$id', data: data);
    return IncidentReportModel.fromJson(response.data);
  }

  Future<void> deleteReport(int id) async {
    await _client.delete('${ApiConstants.reports}/$id');
  }

  Future<IncidentReportModel> approveReport(int id) async {
    final response =
        await _client.put('${ApiConstants.reportsApprove}/$id/approve');
    return IncidentReportModel.fromJson(response.data);
  }

  Future<IncidentReportModel> rejectReport(int id) async {
    final response =
        await _client.put('${ApiConstants.reportsReject}/$id/reject');
    return IncidentReportModel.fromJson(response.data);
  }
}
