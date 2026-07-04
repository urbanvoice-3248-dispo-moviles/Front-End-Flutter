import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/incident_category.dart';
import '../../../domain/usecases/category_usecases.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategories getAllCategories;
  final CreateCategory createCategory;
  final DeleteCategory deleteCategory;

  CategoryBloc({
    required this.getAllCategories,
    required this.createCategory,
    required this.deleteCategory,
  }) : super(CategoryInitial()) {
    on<GetCategoriesEvent>(_onGetAll);
    on<CreateCategoryEvent>(_onCreate);
    on<DeleteCategoryEvent>(_onDelete);
  }

  Future<void> _onGetAll(
      GetCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await getAllCategories();
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onCreate(
      CreateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await createCategory(event.name, event.description);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {
        add(GetCategoriesEvent());
      },
    );
  }

  Future<void> _onDelete(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    final result = await deleteCategory(event.id);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {
        add(GetCategoriesEvent());
      },
    );
  }
}
