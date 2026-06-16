import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/alert.dart';
import '../../../domain/usecases/alert_usecases.dart';

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final GetAllAlerts getAllAlerts;
  final GetAlertsByUser getAlertsByUser;

  AlertBloc({
    required this.getAllAlerts,
    required this.getAlertsByUser,
  }) : super(AlertInitial()) {
    on<GetAllAlertsEvent>(_onGetAllAlerts);
    on<GetAlertsByUserEvent>(_onGetAlertsByUser);
  }

  Future<void> _onGetAllAlerts(
      GetAllAlertsEvent event, Emitter<AlertState> emit) async {
    emit(AlertLoading());
    final result = await getAllAlerts();
    result.fold(
      (failure) => emit(AlertError(failure.message)),
      (alerts) => emit(AlertsLoaded(alerts)),
    );
  }

  Future<void> _onGetAlertsByUser(
      GetAlertsByUserEvent event, Emitter<AlertState> emit) async {
    emit(AlertLoading());
    final result = await getAlertsByUser(event.userId);
    result.fold(
      (failure) => emit(AlertError(failure.message)),
      (alerts) => emit(AlertsLoaded(alerts)),
    );
  }
}
