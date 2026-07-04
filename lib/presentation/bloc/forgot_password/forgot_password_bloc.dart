import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/auth_usecases.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPassword forgotPassword;
  final ResetPassword resetPassword;

  ForgotPasswordBloc({
    required this.forgotPassword,
    required this.resetPassword,
  }) : super(ForgotPasswordInitial()) {
    on<SendForgotPasswordEmailEvent>(_onSendEmail);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSendEmail(SendForgotPasswordEmailEvent event,
      Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    final result = await forgotPassword(event.email);
    result.fold(
      (failure) => emit(ForgotPasswordError(failure.message)),
      (_) => emit(ForgotPasswordTokenSent()),
    );
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    final result = await resetPassword(event.token, event.newPassword);
    result.fold(
      (failure) => emit(ForgotPasswordError(failure.message)),
      (_) => emit(ForgotPasswordSuccess()),
    );
  }
}
