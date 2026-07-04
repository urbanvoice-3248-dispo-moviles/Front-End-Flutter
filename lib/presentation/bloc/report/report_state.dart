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

class ReportVoteSuccess extends ReportState {
  final VoteResponse vote;

  const ReportVoteSuccess(this.vote);

  @override
  List<Object?> get props => [vote];
}

class ReportVoteLoaded extends ReportState {
  final VoteResponse vote;

  const ReportVoteLoaded(this.vote);

  @override
  List<Object?> get props => [vote];
}

class ReportVoteError extends ReportState {
  final String message;

  const ReportVoteError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}
