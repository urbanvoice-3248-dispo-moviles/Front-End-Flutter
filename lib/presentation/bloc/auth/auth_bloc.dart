import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../domain/usecases/profile_usecases.dart';
import '../../../core/network/token_manager.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final CreateProfile createProfile;
  final GetProfileByEmail getProfileByEmail;
  final GetProfileById getProfileById;
  final TokenManager tokenManager;

  AuthBloc({
    required this.loginUser,
    required this.createProfile,
    required this.getProfileByEmail,
    required this.getProfileById,
    required this.tokenManager,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<CheckAuthEvent>(_onCheckAuth);
    on<LogoutEvent>(_onLogout);
    on<CheckSavedSessionEvent>(_onCheckSavedSession);
    on<TermsAcceptedEvent>(_onTermsAccepted);
  }

  Future<void> _onRegister(
      RegisterEvent event, Emitter<AuthState> emit) async {
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
      (failure) => emit(AuthError(_mapFailureMessage(failure.message, 'register'))),
      (profile) {
        tokenManager.saveUserId(profile.id);
        tokenManager.saveUserEmail(profile.email);
        emit(AuthAuthenticated(profile, needsTermsAcceptance: true));
      },
    );
  }

  Future<void> _onLogin(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUser(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(_mapFailureMessage(failure.message, 'login'))),
      (data) async {
        final userId = data['user_id'] as int;
        final profileResult = await getProfileById(userId);
        profileResult.fold(
          (failure) => emit(AuthError('Error al cargar perfil')),
          (profile) async {
            final termsAccepted = await tokenManager.getTermsAccepted();
            emit(AuthAuthenticated(profile,
                needsTermsAcceptance: !termsAccepted));
          },
        );
      },
    );
  }

  Future<void> _onCheckAuth(
      CheckAuthEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = await tokenManager.isLoggedIn();
    if (isLoggedIn) {
      final userId = await tokenManager.getUserId();
      if (userId != null) {
        final profileResult = await getProfileById(userId);
        profileResult.fold(
          (_) => emit(AuthInitial()),
          (profile) {
            tokenManager.saveUserEmail(profile.email);
            emit(AuthAuthenticated(profile));
          },
        );
      } else {
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onCheckSavedSession(
      CheckSavedSessionEvent event, Emitter<AuthState> emit) async {
    emit(CheckingAuth());
    final isLoggedIn = await tokenManager.isLoggedIn();
    if (isLoggedIn) {
      final userId = await tokenManager.getUserId();
      if (userId != null) {
        final profileResult = await getProfileById(userId);
        profileResult.fold(
          (_) async {
            await tokenManager.clearSession();
            emit(AuthInitial());
          },
          (profile) {
            emit(AuthAuthenticated(profile));
          },
        );
      } else {
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogout(
      LogoutEvent event, Emitter<AuthState> emit) async {
    await tokenManager.clearSession();
    emit(AuthInitial());
  }

  Future<void> _onTermsAccepted(
      TermsAcceptedEvent event, Emitter<AuthState> emit) async {
    await tokenManager.setTermsAccepted(true);
    if (state is AuthAuthenticated) {
      final current = state as AuthAuthenticated;
      emit(AuthAuthenticated(current.profile, needsTermsAcceptance: false));
    }
  }

  String _mapFailureMessage(String message, String context) {
    if (message.contains('401') || message.contains('Unauthorized')) {
      return 'Credenciales inválidas';
    }
    if (message.contains('409') || message.contains('already registered')) {
      return 'El correo ya está registrado';
    }
    if (message.contains('400')) {
      return 'Error de validación';
    }
    if (message.contains('Connection') || message.contains('Socket')) {
      return 'Problema de conexión';
    }
    if (context == 'register') return 'Error al registrarse';
    return message;
  }
}
