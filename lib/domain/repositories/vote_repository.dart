import 'package:dartz/dartz.dart';
import '../entities/vote.dart';
import '../../core/errors/failures.dart';

abstract class VoteRepository {
  Future<Either<Failure, VoteResponse>> toggleVote(
      int reportId, String voteType, int userId);

  Future<Either<Failure, VoteResponse>> getVotes(int reportId);
}
