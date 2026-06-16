import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> createProfile({
    required String name,
    required String lastName,
    required int age,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final data = {
        'name': name,
        'last_name': lastName,
        'age': age,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
      };
      final model = await _remoteDataSource.createProfile(data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al crear perfil'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getProfileById(int id) async {
    try {
      final model = await _remoteDataSource.getProfileById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(NotFoundFailure('Perfil no encontrado'));
      }
      return Left(ServerFailure(e.message ?? 'Error al obtener perfil'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getProfileByEmail(String email) async {
    try {
      final model = await _remoteDataSource.getProfileByEmail(email);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(NotFoundFailure('Perfil no encontrado'));
      }
      return Left(ServerFailure(e.message ?? 'Error al obtener perfil'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile({
    required int id,
    required String name,
    required String lastName,
    required int age,
    required String phoneNumber,
  }) async {
    try {
      final data = {
        'name': name,
        'last_name': lastName,
        'age': age,
        'phone_number': phoneNumber,
      };
      final model = await _remoteDataSource.updateProfile(id, data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al actualizar perfil'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(int id) async {
    try {
      await _remoteDataSource.deleteProfile(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al eliminar perfil'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
