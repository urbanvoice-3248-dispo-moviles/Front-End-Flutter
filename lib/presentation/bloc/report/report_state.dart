part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportCreated extends ReportState {
  final IncidentReport report;

  const ReportCreated(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportsLoaded extends ReportState {
  final List<IncidentReport> reports;

  const ReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class ReportDetailLoaded extends ReportState {
  final IncidentReport report;

  const ReportDetailLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportDeleted extends ReportState {}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}
