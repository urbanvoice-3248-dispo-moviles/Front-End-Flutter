import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDataSource {
  final ApiClient _client;

  ProfileRemoteDataSource(this._client);

  Future<UserProfileModel> createProfile(Map<String, dynamic> data) async {
    final response = await _client.post(ApiConstants.profiles, data: data);
    return UserProfileModel.fromJson(response.data);
  }

  Future<UserProfileModel> getProfileById(int id) async {
    final response = await _client.get('${ApiConstants.profiles}/$id');
    return UserProfileModel.fromJson(response.data);
  }

  Future<UserProfileModel> getProfileByEmail(String email) async {
    final response =
        await _client.get('${ApiConstants.profilesByEmail}/$email');
    return UserProfileModel.fromJson(response.data);
  }

  Future<UserProfileModel> updateProfile(
      int id, Map<String, dynamic> data) async {
    final response = await _client.put('${ApiConstants.profiles}/$id',
        data: data);
    return UserProfileModel.fromJson(response.data);
  }

  Future<void> deleteProfile(int id) async {
    await _client.delete('${ApiConstants.profiles}/$id');
  }
}
