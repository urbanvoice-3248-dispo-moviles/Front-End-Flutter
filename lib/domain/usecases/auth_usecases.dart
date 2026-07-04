import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      String email, String password) {
    return repository.login(email, password);
  }
}

class ForgotPassword {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String email) {
    return repository.forgotPassword(email);
  }
}

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      String token, String newPassword) {
    return repository.resetPassword(token, newPassword);
  }
}
