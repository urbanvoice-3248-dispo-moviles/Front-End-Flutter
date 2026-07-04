import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login(
      String email, String password);

  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(String email);

  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
      String token, String newPassword);
}
