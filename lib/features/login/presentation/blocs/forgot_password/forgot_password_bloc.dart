import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/failure_helper.dart';
import '../../../../../core/utils/form_validator.dart';
import '../../../domain/usecases/post_forgot_password.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final PostForgotPassword postForgotPassword;
  final FormValidator formValidator;

  ForgotPasswordBloc({
    required this.postForgotPassword,
    required this.formValidator,
  }) : super(const ForgotPasswordState()) {
    on<EmailSubmitted>(_onEmailSubmitted);
    on<EmailChanged>(_onEmailChanged);
    on<EmailFieldFocused>(_onEmailFieldFocused);
  }

  void _onEmailChanged(EmailChanged event, Emitter<ForgotPasswordState> emit) {
    final email = event.email;
    emit(
      state.copyWith(
        forgotPasswordStatus: ForgotPasswordStatus.initial,
        isEmailValid: formValidator.isUsernameValid(email),
        email: email,
      ),
    );
  }

  void _onEmailFieldFocused(
      EmailFieldFocused event, Emitter<ForgotPasswordState> emit) {
    emit(
      state.copyWith(
        forgotPasswordStatus: ForgotPasswordStatus.initial,
        isEmailValid: true,
        email: '',
      ),
    );
  }

  Future<void> _onEmailSubmitted(
      EmailSubmitted event, Emitter<ForgotPasswordState> emit) async {
    emit(
      state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.loading),
    );

    final email = state.email;
    if (!formValidator.isUsernameValid(email)) {
      emit(
        state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.failure,
          errorMessage: 'Please enter a valid email address',
        ),
      );
      return;
    }

    final failureOrSuccess =
    await postForgotPassword(ForgotPasswordParams(email));

    failureOrSuccess.fold(
          (failure) {
        emit(
          state.copyWith(
            forgotPasswordStatus: ForgotPasswordStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
      },
          (_) {
        emit(
          state.copyWith(
            forgotPasswordStatus: ForgotPasswordStatus.success,
          ),
        );
      },
    );
  }
}
