import '../../domain/entities/vote.dart';

class VoteRequestDto {
  final int reportId;
  final String voteType;

  const VoteRequestDto({required this.reportId, required this.voteType});

  Map<String, dynamic> toJson() => {
        'report_id': reportId,
        'vote_type': voteType,
      };
}

class VoteResponseDto {
  final int? id;
  final int reportId;
  final String? voteType;
  final int upvotes;
  final int downvotes;

  const VoteResponseDto({
    this.id,
    required this.reportId,
    this.voteType,
    required this.upvotes,
    required this.downvotes,
  });

  factory VoteResponseDto.fromJson(Map<String, dynamic> json) {
    return VoteResponseDto(
      id: json['id'] as int?,
      reportId: json['report_id'] as int,
      voteType: json['vote_type'] as String?,
      upvotes: json['upvotes'] as int? ?? 0,
      downvotes: json['downvotes'] as int? ?? 0,
    );
  }

  VoteResponse toEntity() => VoteResponse(
        id: id,
        reportId: reportId,
        voteType: voteType,
        upvotes: upvotes,
        downvotes: downvotes,
      );
}
