import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';
import '../../core/errors/failures.dart';

class CreateProfile {
  final ProfileRepository repository;

  CreateProfile(this.repository);

  Future<Either<Failure, UserProfile>> call({
    required String name,
    required String lastName,
    required int age,
    required String email,
    required String phoneNumber,
    required String password,
  }) {
    return repository.createProfile(
      name: name,
      lastName: lastName,
      age: age,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}

class GetProfileById {
  final ProfileRepository repository;

  GetProfileById(this.repository);

  Future<Either<Failure, UserProfile>> call(int id) {
    return repository.getProfileById(id);
  }
}

class GetProfileByEmail {
  final ProfileRepository repository;

  GetProfileByEmail(this.repository);

  Future<Either<Failure, UserProfile>> call(String email) {
    return repository.getProfileByEmail(email);
  }
}

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, UserProfile>> call({
    required int id,
    required String name,
    required String lastName,
    required int age,
    required String phoneNumber,
  }) {
    return repository.updateProfile(
      id: id,
      name: name,
      lastName: lastName,
      age: age,
      phoneNumber: phoneNumber,
    );
  }
}

class DeleteProfile {
  final ProfileRepository repository;

  DeleteProfile(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteProfile(id);
  }
}
