import 'package:dartz/dartz.dart';
import '../entities/incident_category.dart';
import '../../core/errors/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<IncidentCategory>>> getAllCategories();

  Future<Either<Failure, IncidentCategory>> createCategory(
      String name, String description);

  Future<Either<Failure, IncidentCategory>> updateCategory(
      int id, String name, String description);

  Future<Either<Failure, void>> deleteCategory(int id);
}
