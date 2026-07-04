part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoriesEvent extends CategoryEvent {}

class CreateCategoryEvent extends CategoryEvent {
  final String name;
  final String description;

  const CreateCategoryEvent({required this.name, required this.description});

  @override
  List<Object?> get props => [name, description];
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;

  const DeleteCategoryEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
