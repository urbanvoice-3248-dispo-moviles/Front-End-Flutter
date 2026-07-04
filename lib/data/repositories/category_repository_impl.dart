import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/incident_category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/incident_category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<IncidentCategory>>> getAllCategories() async {
    try {
      final models = await _remoteDataSource.getAllCategories();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener categorías'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentCategory>> createCategory(
      String name, String description) async {
    try {
      final request = CreateCategoryRequest(name: name, description: description);
      final model = await _remoteDataSource.createCategory(request);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al crear categoría'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentCategory>> updateCategory(
      int id, String name, String description) async {
    try {
      final model = await _remoteDataSource.updateCategory(id, {
        'name': name,
        'description': description,
      });
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al actualizar categoría'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await _remoteDataSource.deleteCategory(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al eliminar categoría'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
