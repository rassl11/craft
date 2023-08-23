import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const _tokenKey = 'token';

  final SharedPreferences _sharedPreferences;

  SharedPrefs(this._sharedPreferences);

  Future<bool> setToken(String value) {
    return _sharedPreferences.setString(_tokenKey, value);
  }

  String get token {
    return _sharedPreferences.getString(_tokenKey) ?? '';
  }

  Future<bool> logout() {
    return _sharedPreferences.remove(_tokenKey);
  }
}
