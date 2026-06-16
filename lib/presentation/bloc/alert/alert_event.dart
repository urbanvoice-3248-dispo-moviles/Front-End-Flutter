part of 'alert_bloc.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object?> get props => [];
}

class GetAllAlertsEvent extends AlertEvent {}

class GetAlertsByUserEvent extends AlertEvent {
  final int userId;

  const GetAlertsByUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
