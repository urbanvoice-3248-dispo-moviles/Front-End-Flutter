part of 'route_bloc.dart';

abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object?> get props => [];
}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final RouteAssessment assessment;
  final Map<String, double> origin;
  final Map<String, double> destination;
  final List<List<double>> decodedPath;

  const RouteLoaded(this.assessment, this.origin, this.destination, this.decodedPath);

  @override
  List<Object?> get props => [assessment, origin, destination, decodedPath];
}

class RouteError extends RouteState {
  final String message;

  const RouteError(this.message);

  @override
  List<Object?> get props => [message];
}
