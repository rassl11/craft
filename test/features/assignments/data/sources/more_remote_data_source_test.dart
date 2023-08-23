import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/core/error/exceptions.dart';
import 'package:share/core/shared_prefs.dart';
import 'package:share/core/sources/base_remote_data_source.dart';
import 'package:share/features/assignments/data/models/logout_model.dart';
import 'package:share/features/assignments/data/sources/more_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockPrefs extends Mock implements SharedPrefs {}

// ignore: avoid_implementing_value_types
class MockPackageInfo extends Mock implements PackageInfo {}

void main() {
  late RemoteMoreDataSourceImpl dataSource;
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
    dataSource = RemoteMoreDataSourceImpl(
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

  void setUpMockHttpClientGetSuccess200(String desiredFixture) {
    setUpMockPrefsToReturnToken();
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(desiredFixture, 200));
    setUpMockPackageInfoToReturnVersion();
  }

  void setUpMockHttpClientGetFailure(int statusCode, String desiredFixture) {
    setUpMockPrefsToReturnToken();
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(desiredFixture, statusCode));
    setUpMockPackageInfoToReturnVersion();
  }

  group('logout', () {
    const tLogoutModel = LogoutModel(success: 'success');

    test('should perform GET request with authorization header', () async {
      // arrange
      setUpMockHttpClientGetSuccess200(fixture('login/logout.json'));
      // act
      await dataSource.logout();
      // assert
      verify(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl/auth/revoke-token'),
          headers: {
            contentTypeHeader: 'application/json',
            authorizationHeader: 'Bearer token',
            appVersionHeader: '0.1.0'
          },
        ),
      );
    });

    test('should return LogoutModel if logout is successful', () async {
      // arrange
      setUpMockHttpClientGetSuccess200(fixture('login/logout.json'));
      // act
      final response = await dataSource.logout();
      // assert
      expect(response, tLogoutModel);
    });

    test('should return AuthorizationException if statusCode is 401', () async {
      // arrange
      setUpMockHttpClientGetFailure(401, fixture('login/logout.json'));
      // act
      final call = dataSource.logout;
      // assert
      expect(call, throwsA(const TypeMatcher<AuthorizationException>()));
    });

    test('should return ServerException in other cases', () async {
      // arrange
      setUpMockHttpClientGetFailure(501, fixture('login/logout.json'));
      // act
      final call = dataSource.logout;
      // assert
      expect(call, throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
