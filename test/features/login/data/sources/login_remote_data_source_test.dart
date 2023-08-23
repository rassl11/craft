import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/core/error/exceptions.dart';
import 'package:share/core/shared_prefs.dart';
import 'package:share/core/sources/base_remote_data_source.dart';
import 'package:share/features/login/data/models/forgot_password_model.dart';
import 'package:share/features/login/data/models/login_model.dart';
import 'package:share/features/login/data/sources/login_remote_data_source.dart';
import 'package:share/features/login/domain/usecases/login_user.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockPrefs extends Mock implements SharedPrefs {}

// ignore: avoid_implementing_value_types
class MockPackageInfo extends Mock implements PackageInfo {}

void main() {
  late RemoteLoginDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  late MockPrefs mockPrefs;
  late MockPackageInfo mockPackageInfo;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://craftboxx.herokuapp.com/api/v1/'));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockPrefs = MockPrefs();
    mockPackageInfo = MockPackageInfo();
    dataSource = RemoteLoginDataSourceImpl(
      client: mockHttpClient,
      sharedPrefs: mockPrefs,
      packageInfo: mockPackageInfo,
    );
  });

  void setUpMockPrefsToReturnToken() {
    when(() => mockPrefs.token).thenReturn('token');
  }

  void setUpMockPackageInfoToReturnVersion() {
    when(() => mockPackageInfo.version).thenReturn('0.1.0');
  }

  void setUpMockHttpClientPostSuccess200(String desiredFixture) {
    setUpMockPrefsToReturnToken();
    when(() => mockHttpClient.post(any(),
            headers: any(named: 'headers'), body: any(named: 'body')))
        .thenAnswer((_) async => http.Response(desiredFixture, 200));
    setUpMockPackageInfoToReturnVersion();
  }

  void setUpMockHttpClientPostFailure(int statusCode, String desiredFixture) {
    setUpMockPrefsToReturnToken();
    when(() => mockHttpClient.post(any(),
            headers: any(named: 'headers'), body: any(named: 'body')))
        .thenAnswer((_) async => http.Response(desiredFixture, statusCode));
    setUpMockPackageInfoToReturnVersion();
  }

  group('login', () {
    const tLoginModel = LoginModel(
      accessToken: 'accessToken',
      tokenType: 'tokenType',
    );
    const tLoginParams = LoginParams(
      email: 'email',
      password: 'password',
    );

    test(
        'should perform POST request with the login params '
        'and authorization header', () async {
      // arrange
      setUpMockHttpClientPostSuccess200(fixture('login/login.json'));
      // act
      await dataSource.login(tLoginParams);
      // assert
      verify(
        () => mockHttpClient.post(
          Uri.parse('$baseUrl/auth/create-token'),
          headers: {
            contentTypeHeader: 'application/json',
            authorizationHeader: 'Bearer token',
            appVersionHeader: '0.1.0'
          },
          body: '{"email":"email","password":"password"}',
        ),
      );
    });

    test('should return LoginModel if login is successful', () async {
      // arrange
      setUpMockHttpClientPostSuccess200(fixture('login/login.json'));
      // act
      final response = await dataSource.login(tLoginParams);
      // assert
      expect(response, tLoginModel);
    });

    test('should return AuthorizationException if statusCode is 401', () async {
      // arrange
      setUpMockHttpClientPostFailure(401, fixture('login/login.json'));
      // act
      final call = dataSource.login;
      // assert
      expect(
        () => call(tLoginParams),
        throwsA(const TypeMatcher<AuthorizationException>()),
      );
    });

    test('should return ServerException in other cases', () async {
      // arrange
      setUpMockHttpClientPostFailure(501, fixture('login/login.json'));
      // act
      final call = dataSource.login;
      // assert
      expect(
        () => call(tLoginParams),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });

  group('forgot password', () {
    const tEmail = 'email';
    const tForgotPasswordModel = ForgotPasswordModel(success: 'success');

    test('should perform POST request with authorization header', () async {
      // arrange
      setUpMockHttpClientPostSuccess200(fixture('login/forgot_password.json'));
      // act
      await dataSource.forgotPassword(tEmail);
      // assert
      verify(
        () => mockHttpClient.post(
            Uri.parse('$baseUrl/my/employee/forgot-password'),
            headers: {
              contentTypeHeader: 'application/json',
              authorizationHeader: 'Bearer token',
              appVersionHeader: '0.1.0'
            },
            body: '{"email":"email"}'),
      );
    });

    test('should return LogoutModel if logout is successful', () async {
      // arrange
      setUpMockHttpClientPostSuccess200(fixture('login/forgot_password.json'));
      // act
      final response = await dataSource.forgotPassword(tEmail);
      // assert
      expect(response, tForgotPasswordModel);
    });

    test('should return AuthorizationException if statusCode is 401', () async {
      // arrange
      setUpMockHttpClientPostFailure(
          401, fixture('login/forgot_password.json'));
      // act
      final call = dataSource.forgotPassword;
      // assert
      expect(
        () => call(tEmail),
        throwsA(const TypeMatcher<AuthorizationException>()),
      );
    });

    test('should return ValidationException if statusCode is 422', () async {
      // arrange
      setUpMockHttpClientPostFailure(
          422, fixture('login/forgot_password.json'));
      // act
      final call = dataSource.forgotPassword;
      // assert
      expect(
        () => call(tEmail),
        throwsA(const TypeMatcher<ValidationException>()),
      );
    });

    test('should return ServerException in other cases', () async {
      // arrange
      setUpMockHttpClientPostFailure(
          501, fixture('login/forgot_password.json'));
      // act
      final call = dataSource.forgotPassword;
      // assert
      expect(
        () => call(tEmail),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });
}
