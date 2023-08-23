part of 'forgot_password_bloc.dart';

enum ForgotPasswordStatus {
  initial,
  loading,
  success,
  failure,
}

class ForgotPasswordState extends Equatable {
  final String email;
  final bool? isEmailValid;
  final ForgotPasswordStatus forgotPasswordStatus;
  final String? errorMessage;

  const ForgotPasswordState({
    this.email = '',
    this.isEmailValid,
    this.forgotPasswordStatus = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    String? email,
    bool? isEmailValid,
    ForgotPasswordStatus? forgotPasswordStatus,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        isEmailValid,
        forgotPasswordStatus,
        errorMessage,
      ];
}
