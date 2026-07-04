import 'package:dartz/dartz.dart';
import '../entities/share_session.dart';
import '../../core/errors/failures.dart';

abstract class LocationSharingRepository {
  Future<Either<Failure, UserLiveLocation>> publishLocation({
    required double latitude,
    required double longitude,
    required int userId,
  });

  Future<Either<Failure, List<UserLiveLocation>>> getFriendsLocations(
      int userId);

  Future<Either<Failure, UserLiveLocation?>> getMyLocation(int userId);

  Future<Either<Failure, ShareSession>> startSharing({
    required int targetUserId,
    required int userId,
  });

  Future<Either<Failure, void>> stopSharing({
    required int targetUserId,
    required int userId,
  });

  Future<Either<Failure, List<ShareSession>>> getMyShares(int userId);

  Future<Either<Failure, List<ShareSession>>> getSharedWithMe(int userId);
}
