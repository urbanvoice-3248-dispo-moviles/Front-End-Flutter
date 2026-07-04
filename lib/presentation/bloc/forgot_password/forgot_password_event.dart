part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendForgotPasswordEmailEvent extends ForgotPasswordEvent {
  final String email;

  const SendForgotPasswordEmailEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String token;
  final String newPassword;

  const ResetPasswordEvent({required this.token, required this.newPassword});

  @override
  List<Object?> get props => [token, newPassword];
}
