import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/core/shared_prefs.dart';
import 'package:share/core/sources/base_remote_data_source.dart';
import 'package:share/core/utils/assignments_utils.dart';
import 'package:share/features/assignments/data/models/assignments_data_holder_model.dart';
import 'package:share/features/assignments/data/models/customer_data_holder_model.dart';
import 'package:share/features/assignments/data/sources/assignments_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../models/assignments_data_holder_model_test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockPrefs extends Mock implements SharedPrefs {}

// ignore: avoid_implementing_value_types
class MockPackageInfo extends Mock implements PackageInfo {}

void main() {
  late AssignmentsRemoteDataSourceImpl dataSource;
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
    dataSource = AssignmentsRemoteDataSourceImpl(
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

  void setUpMockHttpClientPutSuccess200(String desiredFixture) {
    setUpMockPrefsToReturnToken();
    when(() => mockHttpClient.put(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => http.Response(desiredFixture, 200));
    setUpMockPackageInfoToReturnVersion();
  }

  group('getAssignments', () {
    final tAssignmentsDataHolderModel = AssignmentsDataHolderModel(
      data: [assignmentModel],
    );

    test(
        'should perform GET request with authorization header and return'
        ' AssignmentsDataHolderModel', () async {
      // arrange
      setUpMockHttpClientGetSuccess200(fixture('assignments/assignments.json'));
      // act
      final result = await dataSource.getAssignments();
      // assert
      expect(result, tAssignmentsDataHolderModel);
      verify(
            () => mockHttpClient.get(
          Uri.parse('$baseUrl/assignments'),
          headers: {
            contentTypeHeader: 'application/json',
            authorizationHeader: 'Bearer token',
            appVersionHeader: '0.1.0'
          },
        ),
      );
    });

    test(
        'should perform GET request with authorization header, return '
            'AssignmentsDataHolderModel and relation', () async {
      // arrange
      setUpMockHttpClientGetSuccess200(fixture('assignments/assignments.json'));
      // act
      final result = await dataSource.getAssignments(withRelation: 'relation');
      // assert
      expect(result, tAssignmentsDataHolderModel);
      verify(
            () => mockHttpClient.get(
          Uri.parse('$baseUrl/assignments?with[]=relation'),
          headers: {
            contentTypeHeader: 'application/json',
            authorizationHeader: 'Bearer token',
            appVersionHeader: '0.1.0'
          },
        ),
      );
    });
  });

  group('getCustomerBy', () {
    const tCustomerAddressModel = CustomerDataHolderModel(
      data: CustomerAddressModel(
        city: 'Hamburg',
        country: 'DE',
        customerId: 2050,
        fullAddress: 'test, Fuhlsbüttlerstr, 22309 Hamburg',
        id: 2449,
        lat: '53.6097700000',
        lng: '10.0504490000',
        mail: 'info@craftb-oxx.de',
        mobile: '',
        name: 'test',
        phone: '',
        province: 'Hamburg',
        street: 'Fuhlsbüttlerstr',
        streetAddon: '405',
        zip: '22309',
      ),
    );

    test(
        'should perform GET request with authorization header and return '
            'CustomerDataHolderModel', () async {
      // arrange
      setUpMockHttpClientGetSuccess200(fixture('assignments/address.json'));
      // act
      final result = await dataSource.getCustomerBy(addressId: 2449);
      // assert
      expect(result, tCustomerAddressModel);
      verify(
            () => mockHttpClient.get(
          Uri.parse('$baseUrl/customers/addresses/2449'),
          headers: {
            contentTypeHeader: 'application/json',
            authorizationHeader: 'Bearer token',
            appVersionHeader: '0.1.0'
          },
        ),
      );
    });
  });

  group('getDetailedAssignment', () {
    test(
        'should perform GET request with authorization header and return'
            ' SingleAssignmentDataHolderModel', () async {
      const String parameters = '''
    with[]=customer_address&
    with[]=employees&
    with[]=tools&
    with[]=vehicles&
    with[]=documentations&
    with[]=documentations.upload&
    with[]=documents&
    with[]=articles
    ''';

      // arrange
      setUpMockHttpClientGetSuccess200(
          fixture('assignments/detailedAssignment.json'));
      // act
      const tAssignmentId = 1;
      final result = await dataSource.getDetailedAssignment(
        assignmentId: tAssignmentId,
      );
      // assert
      expect(result, isA<SingleAssignmentDataHolderModel>());
      verify(
            () => mockHttpClient.get(
          Uri.parse('$baseUrl/assignments/$tAssignmentId?$parameters'),
          headers: {
            contentTypeHeader: 'application/json',
            authorizationHeader: 'Bearer token',
            appVersionHeader: '0.1.0'
          },
        ),
      );
    });
  });

  group('putAssignmentState', () {
    test(
        'should perform PUT request with authorization header and return'
        ' SingleAssignmentDataHolderModel', () async {
      // arrange
      setUpMockHttpClientPutSuccess200(
          fixture('assignments/detailedAssignment.json'));
      // act
      const tAssignmentId = 1;
      final result = await dataSource.putAssignmentState(
        assignmentId: tAssignmentId,
        stateToBeSet: InAppAssignmentState.actionRequired,
      );
      // assert
      expect(result, isA<SingleAssignmentDataHolderModel>());
      verify(
        () => mockHttpClient.put(
          Uri.parse('$baseUrl/assignments/$tAssignmentId'),
          headers: {
            contentTypeHeader: 'application/json',
            authorizationHeader: 'Bearer token',
            appVersionHeader: '0.1.0'
          },
          body: jsonEncode(
            {
              'state': 'DELAYED',
            },
          ),
        ),
      );
    });
  });
}
