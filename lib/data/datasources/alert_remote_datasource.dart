import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/alert_model.dart';

class AlertRemoteDataSource {
  final ApiClient _client;

  AlertRemoteDataSource(this._client);

  Future<List<AlertModel>> getAllAlerts() async {
    final response = await _client.get(ApiConstants.alerts);
    return (response.data as List)
        .map((e) => AlertModel.fromJson(e))
        .toList();
  }

  Future<AlertModel> getAlertById(int id) async {
    final response = await _client.get('${ApiConstants.alerts}/$id');
    return AlertModel.fromJson(response.data);
  }

  Future<List<AlertModel>> getAlertsByUser(int userId) async {
    final response = await _client.get('${ApiConstants.alertsByUser}/$userId');
    return (response.data as List)
        .map((e) => AlertModel.fromJson(e))
        .toList();
  }

  Future<void> deleteAlert(int id) async {
    await _client.delete('${ApiConstants.alerts}/$id');
  }
}
