part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class CreateReportEvent extends ReportEvent {
  final int userId;
  final String title;
  final String description;
  final String incidentType;
  final double latitude;
  final double longitude;
  final String? address;
  final String? mediaUrl;
  final bool isAnonymous;

  const CreateReportEvent({
    required this.userId,
    required this.title,
    required this.description,
    required this.incidentType,
    required this.latitude,
    required this.longitude,
    this.address,
    this.mediaUrl,
    this.isAnonymous = false,
  });

  @override
  List<Object?> get props => [
        userId,
        title,
        description,
        incidentType,
        latitude,
        longitude,
        address ?? '',
        mediaUrl ?? '',
        isAnonymous,
      ];
}

class GetReportsByUserEvent extends ReportEvent {
  final int userId;

  const GetReportsByUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetNearbyReportsEvent extends ReportEvent {
  final double latitude;
  final double longitude;
  final double radiusInKm;

  const GetNearbyReportsEvent({
    required this.latitude,
    required this.longitude,
    this.radiusInKm = 5.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusInKm];
}

class GetReportByIdEvent extends ReportEvent {
  final int id;

  const GetReportByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteReportEvent extends ReportEvent {
  final int id;

  const DeleteReportEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleVoteEvent extends ReportEvent {
  final int reportId;
  final String voteType;
  final int userId;

  const ToggleVoteEvent({
    required this.reportId,
    required this.voteType,
    required this.userId,
  });

  @override
  List<Object?> get props => [reportId, voteType, userId];
}

class GetVotesEvent extends ReportEvent {
  final int reportId;

  const GetVotesEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

class ClearReportErrorEvent extends ReportEvent {}
