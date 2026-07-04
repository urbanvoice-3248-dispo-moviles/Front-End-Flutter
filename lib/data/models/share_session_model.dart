import '../../domain/entities/share_session.dart';

class ShareSessionDto {
  final int id;
  final int ownerUserId;
  final int targetUserId;
  final bool active;
  final DateTime createdAt;

  const ShareSessionDto({
    required this.id,
    required this.ownerUserId,
    required this.targetUserId,
    required this.active,
    required this.createdAt,
  });

  factory ShareSessionDto.fromJson(Map<String, dynamic> json) {
    return ShareSessionDto(
      id: json['id'] as int,
      ownerUserId: json['owner_user_id'] as int,
      targetUserId: json['target_user_id'] as int,
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  ShareSession toEntity() => ShareSession(
        id: id,
        ownerUserId: ownerUserId,
        targetUserId: targetUserId,
        active: active,
        createdAt: createdAt,
      );
}

class PublishLocationRequest {
  final double latitude;
  final double longitude;

  const PublishLocationRequest({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() => {'latitude': latitude, 'longitude': longitude};
}

class UserLiveLocationDto {
  final int userId;
  final double latitude;
  final double longitude;
  final DateTime updatedAt;

  const UserLiveLocationDto({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory UserLiveLocationDto.fromJson(Map<String, dynamic> json) {
    return UserLiveLocationDto(
      userId: json['user_id'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  UserLiveLocation toEntity() => UserLiveLocation(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        updatedAt: updatedAt,
      );
}

class ShareRequestDto {
  final int targetUserId;

  const ShareRequestDto({required this.targetUserId});

  Map<String, dynamic> toJson() => {'target_user_id': targetUserId};
}
