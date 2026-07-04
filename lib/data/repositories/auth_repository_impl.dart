import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../core/network/token_manager.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenManager _tokenManager;

  AuthRepositoryImpl(this._remoteDataSource, this._tokenManager);

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
      String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);
      await _tokenManager.saveToken(response.token);
      await _tokenManager.saveUserId(response.userId);
      await _tokenManager.saveUserEmail(response.email);
      return Right({
        'user_id': response.userId,
        'email': response.email,
        'token': response.token,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(ValidationFailure('Credenciales inválidas'));
      }
      if (e.response?.statusCode == 409) {
        return Left(ServerFailure(
            e.response?.data?['message'] ?? 'Error de autenticación'));
      }
      return Left(ServerFailure(e.message ?? 'Error al iniciar sesión'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(
      String email) async {
    try {
      final response = await _remoteDataSource.forgotPassword(email);
      return Right({
        'message': response.message,
        'token': response.token,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(NotFoundFailure('Correo no registrado'));
      }
      return Left(
          ServerFailure(e.message ?? 'Error al solicitar recuperación'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
      String token, String newPassword) async {
    try {
      final response = await _remoteDataSource.resetPassword(token, newPassword);
      return Right(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return const Left(ValidationFailure('Token inválido o expirado'));
      }
      return Left(ServerFailure(e.message ?? 'Error al restablecer contraseña'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// Needed for the login request
class LoginRequest {
  final String email;
  final String password;
  const LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
