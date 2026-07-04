part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  final int id;

  const GetProfileEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateProfileEvent extends ProfileEvent {
  final int id;
  final String name;
  final String lastName;
  final int age;
  final String phoneNumber;

  const UpdateProfileEvent({
    required this.id,
    required this.name,
    required this.lastName,
    required this.age,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [id, name, lastName, age, phoneNumber];
}

class DeleteProfileEvent extends ProfileEvent {
  final int id;

  const DeleteProfileEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetAlertConfigEvent extends ProfileEvent {
  final int userId;

  const GetAlertConfigEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateAlertConfigEvent extends ProfileEvent {
  final int userId;
  final bool? enabled;
  final double? radiusInKm;
  final bool? notifyByEmail;

  const UpdateAlertConfigEvent({
    required this.userId,
    this.enabled,
    this.radiusInKm,
    this.notifyByEmail,
  });

  @override
  List<Object?> get props => [userId, enabled, radiusInKm, notifyByEmail];
}
