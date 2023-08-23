part of 'logout_bloc.dart';

class LogoutState extends Equatable {
  final Status logoutStatus;

  const LogoutState({this.logoutStatus = Status.initial});

  LogoutState copyWith({Status? logoutStatus}) {
    return LogoutState(
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  List<Object?> get props => [logoutStatus];
}
