import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';
import '../../core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> createProfile({
    required String name,
    required String lastName,
    required int age,
    required String email,
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, UserProfile>> getProfileById(int id);

  Future<Either<Failure, UserProfile>> getProfileByEmail(String email);

  Future<Either<Failure, UserProfile>> updateProfile({
    required int id,
    required String name,
    required String lastName,
    required int age,
    required String phoneNumber,
  });

  Future<Either<Failure, void>> deleteProfile(int id);
}
