import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/alert_config_model.dart';

class AlertConfigRemoteDataSource {
  final ApiClient _client;

  AlertConfigRemoteDataSource(this._client);

  Future<AlertConfigModel> getAlertConfig(int userId) async {
    final response =
        await _client.get('${ApiConstants.alertConfig}/$userId');
    return AlertConfigModel.fromJson(response.data);
  }

  Future<AlertConfigModel> updateAlertConfig(
      int userId, UpdateAlertConfigRequest request) async {
    final response = await _client.put(
      '${ApiConstants.alertConfig}/$userId',
      data: request.toJson(),
    );
    return AlertConfigModel.fromJson(response.data);
  }
}
