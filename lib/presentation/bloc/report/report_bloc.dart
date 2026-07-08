import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/incident_report.dart';
import '../../../domain/entities/vote.dart';
import '../../../domain/usecases/create_report.dart';
import '../../../domain/usecases/vote_usecases.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final CreateReport createReport;
  final GetReportById getReportById;
  final GetReportsByUser getReportsByUser;
  final GetNearbyReports getNearbyReports;
  final DeleteReport deleteReport;
  final ApproveReport approveReport;
  final RejectReport rejectReport;
  final ToggleVote toggleVote;
  final GetVotes getVotes;

  ReportBloc({
    required this.createReport,
    required this.getReportById,
    required this.getReportsByUser,
    required this.getNearbyReports,
    required this.deleteReport,
    required this.approveReport,
    required this.rejectReport,
    required this.toggleVote,
    required this.getVotes,
  }) : super(ReportInitial()) {
    on<CreateReportEvent>(_onCreateReport);
    on<GetReportsByUserEvent>(_onGetReportsByUser);
    on<GetNearbyReportsEvent>(_onGetNearbyReports);
    on<GetReportByIdEvent>(_onGetReportById);
    on<DeleteReportEvent>(_onDeleteReport);
    on<ApproveReportEvent>(_onApproveReport);
    on<RejectReportEvent>(_onRejectReport);
    on<ToggleVoteEvent>(_onToggleVote);
    on<GetVotesEvent>(_onGetVotes);
    on<ClearReportErrorEvent>(_onClearError);
  }

  Future<void> _onCreateReport(
      CreateReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    final result = await createReport(
      userId: event.userId,
      title: event.title,
      description: event.description,
      incidentType: event.incidentType,
      latitude: event.latitude,
      longitude: event.longitude,
      address: event.address,
      mediaUrl: event.mediaUrl,
      isAnonymous: event.isAnonymous,
    );
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (report) => emit(ReportCreated(report)),
    );
  }

  Future<void> _onGetReportsByUser(
      GetReportsByUserEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    final result = await getReportsByUser(event.userId);
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (reports) => emit(ReportsLoaded(reports)),
    );
  }

  Future<void> _onGetNearbyReports(
      GetNearbyReportsEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    final result = await getNearbyReports(
      latitude: event.latitude,
      longitude: event.longitude,
      radiusInKm: event.radiusInKm,
    );
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (reports) => emit(ReportsLoaded(reports)),
    );
  }

  Future<void> _onGetReportById(
      GetReportByIdEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    final result = await getReportById(event.id);
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (report) => emit(ReportDetailLoaded(report)),
    );
  }

  Future<void> _onDeleteReport(
      DeleteReportEvent event, Emitter<ReportState> emit) async {
    final result = await deleteReport(event.id);
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (_) => emit(ReportDeleted()),
    );
  }

  Future<void> _onApproveReport(
      ApproveReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    final result = await approveReport(event.id);
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (report) => emit(ReportApproved(report)),
    );
  }

  Future<void> _onRejectReport(
      RejectReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    final result = await rejectReport(event.id);
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (report) => emit(ReportRejected(report)),
    );
  }

  Future<void> _onToggleVote(
      ToggleVoteEvent event, Emitter<ReportState> emit) async {
    final result =
        await toggleVote(event.reportId, event.voteType, event.userId);
    result.fold(
      (failure) => emit(ReportVoteError(failure.message)),
      (vote) => emit(ReportVoteSuccess(vote)),
    );
  }

  Future<void> _onGetVotes(
      GetVotesEvent event, Emitter<ReportState> emit) async {
    final result = await getVotes(event.reportId);
    result.fold(
      (failure) => emit(ReportVoteError(failure.message)),
      (vote) => emit(ReportVoteLoaded(vote)),
    );
  }

  void _onClearError(
      ClearReportErrorEvent event, Emitter<ReportState> emit) {
    if (state is ReportError) {
      emit(ReportInitial());
    }
  }
}
