import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/shared_prefs.dart';
import '../../../../core/sources/base_remote_data_source.dart';
import '../../domain/usecases/login_user.dart';
import '../models/forgot_password_model.dart';
import '../models/login_model.dart';

abstract class RemoteLoginDataSource {
  Future<LoginModel> login(LoginParams params);

  Future<ForgotPasswordModel> forgotPassword(String email);
}

class RemoteLoginDataSourceImpl extends BaseRemoteDataSource
    implements RemoteLoginDataSource {
  final http.Client client;

  RemoteLoginDataSourceImpl({
    required this.client,
    required SharedPrefs sharedPrefs,
    required PackageInfo packageInfo,
  }) : super(sharedPrefs: sharedPrefs, packageInfo: packageInfo);

  @override
  Future<LoginModel> login(LoginParams params) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/create-token'),
      headers: getHeaders(),
      body: jsonEncode(params,
          toEncodable: (Object? value) => value is LoginParams
              ? LoginParams.toJson(value)
              : throw UnsupportedError('Cannot convert to JSON: $value')),
    );

    return LoginModel.fromJson(handleResponse(response));
  }

  @override
  Future<ForgotPasswordModel> forgotPassword(String email) async {
    final response = await client.post(
      Uri.parse('$baseUrl/my/employee/forgot-password'),
      headers: getHeaders(),
      body: jsonEncode({'email': email}),
    );

    return ForgotPasswordModel.fromJson(handleResponse(response));
  }
}
