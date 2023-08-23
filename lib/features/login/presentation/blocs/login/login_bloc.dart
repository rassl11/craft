import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/repositories/authentication_repository.dart';
import '../../../../../core/utils/failure_helper.dart';
import '../../../../../core/utils/form_validator.dart';
import '../../../domain/usecases/login_user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUser loginUser;
  final FormValidator formValidator;
  final AuthenticationRepository authenticationRepository;

  LoginBloc({
    required this.loginUser,
    required this.formValidator,
    required this.authenticationRepository,
  }) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginUsernameChanged>(_onLoginUsernameChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggle);
    on<LoginSwitcherToggled>(_onSwitchToggle);
    on<LoginTermsAccepted>(_onTermsAccepted);
    on<LoginTermsRejected>(_onTermsRejected);
    on<LoginFieldFocused>(_loginFieldFocused);
    on<PasswordFieldFocused>(_passwordFieldFocused);
  }

  void _onLoginUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = event.username;
    emit(
      state.copyWith(
        loginStatus: LoginStatus.initial,
        isUsernameValid: formValidator.isUsernameValid(username),
        username: username,
      ),
    );
  }

  void _loginFieldFocused(LoginFieldFocused event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        loginStatus: LoginStatus.initial,
        isUsernameValid: true,
        username: '',
      ),
    );
  }

  void _passwordFieldFocused(
    PasswordFieldFocused event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        loginStatus: LoginStatus.initial,
        isPasswordValid: true,
        password: '',
      ),
    );
  }

  void _onSwitchToggle(LoginSwitcherToggled event, Emitter<LoginState> emit) {
    switch (state.termsState) {
      case TermsState.initial:
      case TermsState.rejected:
      case TermsState.dialogCalled:
        emit(state.copyWith(termsState: TermsState.accepted));
        break;
      case TermsState.accepted:
        emit(state.copyWith(
          termsState: TermsState.rejected,
          loginStatus: LoginStatus.initial,
        ));
        break;
    }
  }

  void _onTermsAccepted(LoginTermsAccepted event, Emitter<LoginState> emit) {
    emit(state.copyWith(termsState: TermsState.accepted));
    add(LoginSubmitted());
  }

  void _onTermsRejected(LoginTermsRejected event, Emitter<LoginState> emit) {
    emit(state.copyWith(termsState: TermsState.rejected));
  }

  void _onPasswordVisibilityToggle(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = event.password;
    emit(
      state.copyWith(
        loginStatus: LoginStatus.initial,
        isPasswordValid: formValidator.isPasswordValid(password),
        password: password,
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final isUsernameValid = formValidator.isUsernameValid(state.username);
    final isPasswordValid = formValidator.isPasswordValid(state.password);
    if (!isUsernameValid || !isPasswordValid) {
      const messageText = 'Please, enter valid credentials';
      emit(
        state.copyWith(
          isUsernameValid: isUsernameValid,
          isPasswordValid: isPasswordValid,
          loginStatus: LoginStatus.failure,
          errorMessage: messageText,
        ),
      );
      return;
    }

    if (state.termsState != TermsState.accepted) {
      emit(
        state.copyWith(
          termsState: TermsState.dialogCalled,
          loginStatus: LoginStatus.initial,
        ),
      );
      return;
    }

    emit(state.copyWith(loginStatus: LoginStatus.loading));

    final failureOrToken = await loginUser(
      LoginParams(
        email: state.username.trim(),
        password: state.password.trim(),
      ),
    );
    await failureOrToken.fold(
      (failure) async => emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      ),
      (loginData) async {
        await authenticationRepository.logIn(token: loginData.accessToken);
        emit(const LoginState(loginStatus: LoginStatus.success));
      },
    );
  }
}
