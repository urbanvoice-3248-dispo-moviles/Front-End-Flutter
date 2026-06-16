part of 'alert_bloc.dart';

abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object?> get props => [];
}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertsLoaded extends AlertState {
  final List<Alert> alerts;

  const AlertsLoaded(this.alerts);

  @override
  List<Object?> get props => [alerts];
}

class AlertError extends AlertState {
  final String message;

  const AlertError(this.message);

  @override
  List<Object?> get props => [message];
}
