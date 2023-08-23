part of 'logout_bloc.dart';

abstract class LogoutEvent {
  const LogoutEvent();
}

class LogoutSubmitted extends LogoutEvent {}
