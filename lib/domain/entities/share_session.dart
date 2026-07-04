import 'package:equatable/equatable.dart';

class ShareSession extends Equatable {
  final int id;
  final int ownerUserId;
  final int targetUserId;
  final bool active;
  final DateTime createdAt;

  const ShareSession({
    required this.id,
    required this.ownerUserId,
    required this.targetUserId,
    required this.active,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, ownerUserId, targetUserId, active, createdAt];
}

class UserLiveLocation extends Equatable {
  final int userId;
  final double latitude;
  final double longitude;
  final DateTime updatedAt;

  const UserLiveLocation({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [userId, latitude, longitude, updatedAt];
}

class TrustedContact extends Equatable {
  final int userId;
  final String name;
  final String lastName;
  final String email;
  final String sharedSince;

  const TrustedContact({
    required this.userId,
    required this.name,
    required this.lastName,
    required this.email,
    required this.sharedSince,
  });

  @override
  List<Object?> get props => [userId, name, lastName, email, sharedSince];
}
