import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/share_session.dart';
import '../repositories/location_sharing_repository.dart';

class PublishLocation {
  final LocationSharingRepository repository;

  PublishLocation(this.repository);

  Future<Either<Failure, UserLiveLocation>> call({
    required double latitude,
    required double longitude,
    required int userId,
  }) {
    return repository.publishLocation(
      latitude: latitude,
      longitude: longitude,
      userId: userId,
    );
  }
}

class GetFriendsLocations {
  final LocationSharingRepository repository;

  GetFriendsLocations(this.repository);

  Future<Either<Failure, List<UserLiveLocation>>> call(int userId) {
    return repository.getFriendsLocations(userId);
  }
}

class StartSharing {
  final LocationSharingRepository repository;

  StartSharing(this.repository);

  Future<Either<Failure, ShareSession>> call({
    required int targetUserId,
    required int userId,
  }) {
    return repository.startSharing(targetUserId: targetUserId, userId: userId);
  }
}

class StopSharing {
  final LocationSharingRepository repository;

  StopSharing(this.repository);

  Future<Either<Failure, void>> call({
    required int targetUserId,
    required int userId,
  }) {
    return repository.stopSharing(targetUserId: targetUserId, userId: userId);
  }
}

class GetMyShares {
  final LocationSharingRepository repository;

  GetMyShares(this.repository);

  Future<Either<Failure, List<ShareSession>>> call(int userId) {
    return repository.getMyShares(userId);
  }
}

class GetSharedWithMe {
  final LocationSharingRepository repository;

  GetSharedWithMe(this.repository);

  Future<Either<Failure, List<ShareSession>>> call(int userId) {
    return repository.getSharedWithMe(userId);
  }
}
