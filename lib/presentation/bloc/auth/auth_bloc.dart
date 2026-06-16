import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/profile_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateProfile createProfile;
  final GetProfileByEmail getProfileByEmail;
  final GetProfileById getProfileById;

  AuthBloc({
    required this.createProfile,
    required this.getProfileByEmail,
    required this.getProfileById,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<CheckAuthEvent>(_onCheckAuth);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await createProfile(
      name: event.name,
      lastName: event.lastName,
      age: event.age,
      email: event.email,
      phoneNumber: event.phoneNumber,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (profile) => emit(AuthAuthenticated(profile)),
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getProfileByEmail(event.email);
    result.fold(
      (failure) => emit(const AuthError('Credenciales inválidas')),
      (profile) => emit(AuthAuthenticated(profile)),
    );
  }

  void _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }
}
