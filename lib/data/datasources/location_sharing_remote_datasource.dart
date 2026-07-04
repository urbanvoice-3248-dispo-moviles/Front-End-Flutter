import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/share_session_model.dart';

class LocationSharingRemoteDataSource {
  final ApiClient _client;

  LocationSharingRemoteDataSource(this._client);

  Future<UserLiveLocationDto> publishLocation(
      double latitude, double longitude, int userId) async {
    final response = await _client.put(
      ApiConstants.locationSharingPublish,
      data: PublishLocationRequest(latitude: latitude, longitude: longitude)
          .toJson(),
      headers: {'X-User-ID': userId.toString()},
    );
    return UserLiveLocationDto.fromJson(response.data);
  }

  Future<List<UserLiveLocationDto>> getFriendsLocations(int userId) async {
    final response = await _client.get(
      ApiConstants.locationSharingFriends,
      headers: {'X-User-ID': userId.toString()},
    );
    return (response.data as List)
        .map((e) => UserLiveLocationDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserLiveLocationDto?> getMyLocation(int userId) async {
    try {
      final response = await _client.get(
        ApiConstants.locationSharingMe,
        headers: {'X-User-ID': userId.toString()},
      );
      if (response.data == null) return null;
      return UserLiveLocationDto.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<ShareSessionDto> startSharing(int targetUserId, int userId) async {
    final response = await _client.post(
      ApiConstants.locationSharingShare,
      data: ShareRequestDto(targetUserId: targetUserId).toJson(),
      headers: {'X-User-ID': userId.toString()},
    );
    return ShareSessionDto.fromJson(response.data);
  }

  Future<void> stopSharing(int targetUserId, int userId) async {
    await _client.delete(
      '${ApiConstants.locationSharingShare}/$targetUserId',
      headers: {'X-User-ID': userId.toString()},
    );
  }

  Future<List<ShareSessionDto>> getMyShares(int userId) async {
    final response = await _client.get(
      ApiConstants.locationSharingShares,
      headers: {'X-User-ID': userId.toString()},
    );
    return (response.data as List)
        .map((e) => ShareSessionDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ShareSessionDto>> getSharedWithMe(int userId) async {
    final response = await _client.get(
      ApiConstants.locationSharingSharedWithMe,
      headers: {'X-User-ID': userId.toString()},
    );
    return (response.data as List)
        .map((e) => ShareSessionDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
