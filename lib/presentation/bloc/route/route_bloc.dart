import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/route_assessment.dart';
import '../../../domain/usecases/route_usecases.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final AssessRoute assessRoute;

  RouteBloc({required this.assessRoute}) : super(RouteInitial()) {
    on<AssessRouteEvent>(_onAssess);
    on<ClearRouteEvent>(_onClear);
  }

  Future<void> _onAssess(
      AssessRouteEvent event, Emitter<RouteState> emit) async {
    emit(RouteLoading());
    final waypoints = event.waypoints;
    final result = await assessRoute(waypoints);
    result.fold(
      (failure) => emit(RouteError(failure.message)),
      (assessment) =>
          emit(RouteLoaded(assessment, event.origin, event.destination, event.decodedPath)),
    );
  }

  void _onClear(ClearRouteEvent event, Emitter<RouteState> emit) {
    emit(RouteInitial());
  }
}
