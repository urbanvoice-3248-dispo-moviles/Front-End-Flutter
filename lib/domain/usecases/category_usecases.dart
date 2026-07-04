import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/incident_category.dart';
import '../repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<Either<Failure, List<IncidentCategory>>> call() {
    return repository.getAllCategories();
  }
}

class CreateCategory {
  final CategoryRepository repository;

  CreateCategory(this.repository);

  Future<Either<Failure, IncidentCategory>> call(
      String name, String description) {
    return repository.createCategory(name, description);
  }
}

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteCategory(id);
  }
}
