part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class EmailSubmitted extends ForgotPasswordEvent {}

class EmailFieldFocused extends ForgotPasswordEvent {}

class EmailChanged extends ForgotPasswordEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}
