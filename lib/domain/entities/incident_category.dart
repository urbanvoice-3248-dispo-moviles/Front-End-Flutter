import 'package:equatable/equatable.dart';

class IncidentCategory extends Equatable {
  final int id;
  final String name;
  final String description;

  const IncidentCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}
