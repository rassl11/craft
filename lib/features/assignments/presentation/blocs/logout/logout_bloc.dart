import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/repositories/authentication_repository.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/logout_user.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUser _logoutUser;
  final AuthenticationRepository _authenticationRepository;

  LogoutBloc({
    required LogoutUser logoutUser,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _logoutUser = logoutUser,
        super(const LogoutState()) {
    on<LogoutSubmitted>(_onLogoutSubmitted);
  }

  Future<void> _onLogoutSubmitted(
    LogoutSubmitted event,
    Emitter<LogoutState> emit,
  ) async {
    emit(state.copyWith(logoutStatus: Status.loading));
    final failureOrSuccess = await _logoutUser(NoParams());

    await _authenticationRepository.logOut();

    failureOrSuccess.fold(
      (failure) => emit(
        state.copyWith(
          logoutStatus: Status.error,
        ),
      ),
      (_) => emit(state.copyWith(logoutStatus: Status.loaded)),
    );
  }
}
