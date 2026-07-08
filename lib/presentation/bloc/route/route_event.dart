part of 'route_bloc.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object?> get props => [];
}

class AssessRouteEvent extends RouteEvent {
  final List<Map<String, double>> waypoints;
  final Map<String, double> origin;
  final Map<String, double> destination;
  final List<List<double>> decodedPath;

  const AssessRouteEvent({
    required this.waypoints,
    required this.origin,
    required this.destination,
    required this.decodedPath,
  });

  @override
  List<Object?> get props => [waypoints, origin, destination, decodedPath];
}

class ClearRouteEvent extends RouteEvent {}
