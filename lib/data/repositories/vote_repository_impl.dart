import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/vote.dart';
import '../../domain/repositories/vote_repository.dart';
import '../datasources/vote_remote_datasource.dart';

class VoteRepositoryImpl implements VoteRepository {
  final VoteRemoteDataSource _remoteDataSource;

  VoteRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, VoteResponse>> toggleVote(
      int reportId, String voteType, int userId) async {
    try {
      final dto =
          await _remoteDataSource.toggleVote(reportId, voteType, userId);
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al votar'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VoteResponse>> getVotes(int reportId) async {
    try {
      final dto = await _remoteDataSource.getVotes(reportId);
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Error al obtener votos'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
