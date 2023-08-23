import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/shared_prefs.dart';
import '../../../../core/sources/base_remote_data_source.dart';
import '../../../assignments/data/models/logout_model.dart';

abstract class RemoteMoreDataSource {
  Future<LogoutModel> logout();
}

class RemoteMoreDataSourceImpl extends BaseRemoteDataSource
    implements RemoteMoreDataSource {
  final http.Client _client;

  RemoteMoreDataSourceImpl({
    required http.Client client,
    required SharedPrefs sharedPrefs,
    required PackageInfo packageInfo,
  })  : _client = client,
        super(
          sharedPrefs: sharedPrefs,
          packageInfo: packageInfo,
        );

  @override
  Future<LogoutModel> logout() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/auth/revoke-token'),
      headers: getHeaders(),
    );

    return LogoutModel.fromJson(handleResponse(response));
  }
}
