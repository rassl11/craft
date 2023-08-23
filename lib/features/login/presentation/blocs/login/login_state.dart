part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

enum TermsState { initial, dialogCalled, accepted, rejected }

class LoginState extends Equatable {
  final bool? isUsernameValid;
  final bool? isPasswordValid;
  final bool isPasswordVisible;
  final String username;
  final String password;
  final LoginStatus loginStatus;
  final TermsState termsState;
  final String? errorMessage;

  const LoginState({
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isUsernameValid,
    this.isPasswordValid,
    this.loginStatus = LoginStatus.initial,
    this.termsState = TermsState.initial,
    this.errorMessage,
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? isUsernameValid,
    bool? isPasswordValid,
    bool? isPasswordVisible,
    LoginStatus? loginStatus,
    TermsState? termsState,
    String? errorMessage,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      loginStatus: loginStatus ?? this.loginStatus,
      termsState: termsState ?? this.termsState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        username,
        password,
        isUsernameValid,
        isPasswordValid,
        isPasswordVisible,
        loginStatus,
        termsState,
        errorMessage,
      ];

  @override
  String toString() {
    return '''
    LoginState {
      username: $username,
      password: $password,
      isUsernameValid: $isUsernameValid,
      isPasswordValid: $isPasswordValid,
      isPasswordVisible: $isPasswordVisible,
      loginStatus: $loginStatus,
      termsState: $termsState,
      errorMessage: $errorMessage,
    }''';
  }
}
