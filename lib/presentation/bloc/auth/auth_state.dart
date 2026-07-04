part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class CheckingAuth extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserProfile profile;
  final bool needsTermsAcceptance;

  const AuthAuthenticated(this.profile, {this.needsTermsAcceptance = false});

  @override
  List<Object?> get props => [profile, needsTermsAcceptance];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
