import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/vote.dart';
import '../repositories/vote_repository.dart';

class ToggleVote {
  final VoteRepository repository;

  ToggleVote(this.repository);

  Future<Either<Failure, VoteResponse>> call(
      int reportId, String voteType, int userId) {
    return repository.toggleVote(reportId, voteType, userId);
  }
}

class GetVotes {
  final VoteRepository repository;

  GetVotes(this.repository);

  Future<Either<Failure, VoteResponse>> call(int reportId) {
    return repository.getVotes(reportId);
  }
}
