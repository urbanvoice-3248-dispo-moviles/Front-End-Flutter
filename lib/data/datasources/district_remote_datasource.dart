import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/district_model.dart';

class DistrictRemoteDataSource {
  final ApiClient _client;

  DistrictRemoteDataSource(this._client);

  Future<List<DistrictModel>> getAllDistricts() async {
    final response = await _client.get(ApiConstants.districts);
    return (response.data as List)
        .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DistrictModel> getDistrictById(int id) async {
    final response = await _client.get('${ApiConstants.districts}/$id');
    return DistrictModel.fromJson(response.data);
  }

  Future<List<DistrictModel>> getDangerousDistricts(
      {int minRiskLevel = 3}) async {
    final response = await _client.get(
      ApiConstants.districtsDangerous,
      queryParameters: {'minRiskLevel': minRiskLevel},
    );
    return (response.data as List)
        .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
