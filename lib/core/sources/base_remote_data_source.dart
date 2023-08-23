import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../entities/craftbox_error.dart';
import '../error/exceptions.dart';
import '../models/error_model.dart';
import '../shared_prefs.dart';

const baseUrl = '';
const contentTypeHeader = 'Content-Type';
const authorizationHeader = 'Authorization';
const appVersionHeader = 'app-version';

const uploadFile1 = 'uploadFile1';
const uploadFile2 = 'uploadFile2';
const executorFilename = 'ausfuhrender.png';

enum DocumentationStatus {
  acceptedWoComment('ACCEPTED_WO_COMMENT'),
  acceptedWithComment('ACCEPTED_WITH_COMMENT'),
  declined('DECLINED');

  final String name;

  const DocumentationStatus(this.name);
}

enum ContentType {
  json('application/json'),
  form('application/x-www-form-urlencoded');

  final String name;

  const ContentType(this.name);
}

class BaseRemoteDataSource {
  final SharedPrefs _sharedPrefs;
  final PackageInfo _packageInfo;

  BaseRemoteDataSource({
    required SharedPrefs sharedPrefs,
    required PackageInfo packageInfo,
  })
      : _packageInfo = packageInfo,
        _sharedPrefs = sharedPrefs;

  Map<String, String> getHeaders({
    ContentType contentType = ContentType.json,
  }) {
    final token = _sharedPrefs.token;
    return {
      contentTypeHeader: contentType.name,
      authorizationHeader: 'Bearer $token',
      appVersionHeader: _packageInfo.version,
    };
  }

  Map<String, dynamic> handleResponse(http.Response response) {
    log(
      '''
      URL: ${response.request}, \nHeaders: ${response.request?.headers}, 
      \nCode: ${response.statusCode}, \nBody: ${response.body}
      ''',
    );

    final statusCode = response.statusCode;
    final responseBody = response.body;
    switch (statusCode) {
      case 200:
        return responseBody != '[]'
            ? json.decode(responseBody) as Map<String, dynamic>
            : <String, dynamic>{};
      case 401:
        throw AuthorizationException();
      case 422:
        throw ValidationException();
      default:
        final decodedJson = json.decode(responseBody) as Map<String, dynamic>;
        final error = decodedJson['error'] != null
            ? CraftboxErrorModel.fromJson(
          decodedJson['error'] as Map<String, dynamic>,
        )
            : null;
        throw ServerException(code: statusCode, error: error);
    }
  }

  void handleStreamedResponse(StreamedResponse response,
      {required VoidCallback onSuccess,
        required Function(Exception) onFailure}) {
    log(
      '''
      URL: ${response.request}, \nHeaders: ${response.request?.headers}, 
      \nCode: ${response.statusCode}
      ''',
    );

    final statusCode = response.statusCode;
    switch (statusCode) {
      case 200:
        onSuccess();
        break;
      case 401:
        onFailure(AuthorizationException());
        break;
      case 422:
        onFailure(ValidationException());
        break;
      default:
        const errorMsg = 'Failed to handle a streamed response';
        onFailure(
          ServerException(
            code: statusCode,
            error: CraftboxError(
              code: statusCode.toString(),
              httpCode: statusCode.toString(),
              message: errorMsg,
              displayMessage: errorMsg,
            ),
          ),
        );
        break;
    }
  }
}
