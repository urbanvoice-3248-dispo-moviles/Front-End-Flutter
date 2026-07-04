import '../../domain/entities/incident_category.dart';

class IncidentCategoryModel {
  final int id;
  final String name;
  final String description;

  const IncidentCategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory IncidentCategoryModel.fromJson(Map<String, dynamic> json) {
    return IncidentCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };

  IncidentCategory toEntity() => IncidentCategory(
        id: id,
        name: name,
        description: description,
      );
}

class CreateCategoryRequest {
  final String name;
  final String description;

  const CreateCategoryRequest({required this.name, required this.description});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };
}
