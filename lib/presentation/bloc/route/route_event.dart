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

  const AssessRouteEvent({
    required this.waypoints,
    required this.origin,
    required this.destination,
  });

  @override
  List<Object?> get props => [waypoints, origin, destination];
}

class ClearRouteEvent extends RouteEvent {}
