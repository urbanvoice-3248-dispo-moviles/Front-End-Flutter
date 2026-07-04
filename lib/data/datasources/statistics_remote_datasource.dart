import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/auth_models.dart';

class StatisticsRemoteDataSource {
  final ApiClient _client;

  StatisticsRemoteDataSource(this._client);

  Future<StatisticsResponseDto> getStatistics() async {
    final response = await _client.get(ApiConstants.reportsStatistics);
    return StatisticsResponseDto.fromJson(response.data);
  }
}
