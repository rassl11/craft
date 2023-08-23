import 'dart:async';

import '../shared_prefs.dart';

class AuthenticationRepository {
  final SharedPrefs _sharedPrefs;
  final _controller = StreamController<AuthenticationStatus>();

  AuthenticationRepository(this._sharedPrefs);

  Stream<AuthenticationStatus> get status async* {
    if (_sharedPrefs.token.isNotEmpty) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unknown;
    }

    yield* _controller.stream;
  }

  Future<void> logIn({required String token}) async {
    await _sharedPrefs.setToken(token);
    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> unauthenticate() async {
    await _sharedPrefs.logout();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> logOut() async {
    await _sharedPrefs.logout();
    _controller.add(AuthenticationStatus.unknown);
  }

  void dispose() => _controller.close();
}

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}
