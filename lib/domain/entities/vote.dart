import 'package:equatable/equatable.dart';

class VoteResponse extends Equatable {
  final int? id;
  final int reportId;
  final String? voteType;
  final int upvotes;
  final int downvotes;

  const VoteResponse({
    this.id,
    required this.reportId,
    this.voteType,
    required this.upvotes,
    required this.downvotes,
  });

  @override
  List<Object?> get props => [id, reportId, voteType, upvotes, downvotes];
}
