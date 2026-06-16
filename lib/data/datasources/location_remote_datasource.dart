import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/location_model.dart';

class LocationRemoteDataSource {
  final ApiClient _client;

  LocationRemoteDataSource(this._client);

  Future<List<LocationModel>> getAllLocations() async {
    final response = await _client.get(ApiConstants.locations);
    return (response.data as List)
        .map((e) => LocationModel.fromJson(e))
        .toList();
  }

  Future<LocationModel> getLocationById(int id) async {
    final response = await _client.get('${ApiConstants.locations}/$id');
    return LocationModel.fromJson(response.data);
  }

  Future<List<LocationModel>> getNearbyLocations(
      double latitude, double longitude, double radiusInKm) async {
    final response = await _client.get(
      ApiConstants.locationsNearby,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radiusInKm': radiusInKm,
      },
    );
    return (response.data as List)
        .map((e) => LocationModel.fromJson(e))
        .toList();
  }

  Future<List<LocationModel>> getLocationsByDistrict(String district) async {
    final response =
        await _client.get('${ApiConstants.locationsByDistrict}/$district');
    return (response.data as List)
        .map((e) => LocationModel.fromJson(e))
        .toList();
  }

  Future<List<LocationModel>> getDangerousLocations(
      {int minRiskLevel = 3}) async {
    final response = await _client.get(
      ApiConstants.locationsDangerous,
      queryParameters: {'minRiskLevel': minRiskLevel},
    );
    return (response.data as List)
        .map((e) => LocationModel.fromJson(e))
        .toList();
  }
}
