import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/auth_models.dart';

class AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSource(this._client);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _client.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    final response = await _client.post(
      ApiConstants.forgotPassword,
      data: ForgotPasswordRequest(email: email).toJson(),
    );
    return ForgotPasswordResponse.fromJson(response.data);
  }

  Future<Map<String, dynamic>> resetPassword(
      String token, String newPassword) async {
    final response = await _client.post(
      ApiConstants.resetPassword,
      data: ResetPasswordRequest(token: token, newPassword: newPassword)
          .toJson(),
    );
    return response.data as Map<String, dynamic>;
  }
}
