import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/core/shared_prefs.dart';
import 'package:share/core/sources/base_remote_data_source.dart';
import 'package:share/core/sources/craftbox_multipart_request.dart';
import 'package:share/features/assignments/data/models/documentation_model.dart';
import 'package:share/features/assignments/data/sources/documentation_remote_data_source.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockPrefs extends Mock implements SharedPrefs {}

// ignore: avoid_implementing_value_types
class MockPackageInfo extends Mock implements PackageInfo {}

class MockCraftboxRequest extends Mock implements CraftboxMultipartRequest {}

class MockMultipartRequest extends Mock implements http.MultipartRequest {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockPrefs mockPrefs;
  late MockPackageInfo mockPackageInfo;
  late http.MultipartRequest mockMultipartRequest;
  late CraftboxMultipartRequest mockGeneralMultipartRequest;
  late DocumentationRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockPrefs = MockPrefs();
    mockPackageInfo = MockPackageInfo();
    mockGeneralMultipartRequest = MockCraftboxRequest();
    mockMultipartRequest = MockMultipartRequest();
    dataSource = DocumentationRemoteDataSourceImpl(
      client: mockHttpClient,
      sharedPrefs: mockPrefs,
      packageInfo: mockPackageInfo,
      multipartRequest: mockGeneralMultipartRequest,
    );
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://craftboxx.herokuapp.com/api/v1/'));
  });

  test('should post documentation', () async {
    const tDocumentationModel = DocumentationModel.postTime(
      assignmentId: 1,
      workingTime: 1,
      breakTime: 0,
      drivingTime: 0,
      type: DocumentationType.time,
      title: 'title',
      description: 'description',
    );

    // arrange
    when(() => mockPrefs.token).thenReturn('token');
    when(() => mockHttpClient.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ))
        .thenAnswer((_) async =>
            http.Response(fixture('documentation/documentation.json'), 200));
    when(() => mockPackageInfo.version).thenReturn('0.1.0');
    // act
    await dataSource.postTime(
      tDocumentationModel,
    );
    // assert
    verify(
      () => mockHttpClient.post(
        Uri.parse('$baseUrl/documentations'),
        headers: {
          contentTypeHeader: 'application/json',
          authorizationHeader: 'Bearer token',
          appVersionHeader: '0.1.0'
        },
        body: jsonEncode(tDocumentationModel.toJson()),
      ),
    );
  });

  test('should post note documentation', () async {
    const tDocumentationModel = DocumentationModel.postNote(
      assignmentId: 1,
      type: DocumentationType.note,
      title: 'title',
      description: 'description',
    );

    // arrange
    when(() => mockPrefs.token).thenReturn('token');
    when(() => mockHttpClient.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ))
        .thenAnswer((_) async =>
            http.Response(fixture('documentation/documentation.json'), 200));
    when(() => mockPackageInfo.version).thenReturn('0.1.0');
    // act
    await dataSource.postNote(
      tDocumentationModel,
    );
    // assert
    verify(
      () => mockHttpClient.post(
        Uri.parse('$baseUrl/documentations'),
        headers: {
          contentTypeHeader: 'application/x-www-form-urlencoded',
          authorizationHeader: 'Bearer token',
          appVersionHeader: '0.1.0'
        },
        body: tDocumentationModel.toForm(),
      ),
    );
  });

  test('should edit note documentation', () async {
    const tDocumentationModel = DocumentationModel.postEditNote(
      id: 1,
      assignmentId: 1,
      type: DocumentationType.note,
      title: 'title1',
      description: 'description1',
    );

    // arrange
    when(() => mockPrefs.token).thenReturn('token');
    when(() => mockHttpClient.put(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ))
        .thenAnswer((_) async =>
            http.Response(fixture('documentation/documentation.json'), 200));
    when(() => mockPackageInfo.version).thenReturn('0.1.0');
    // act
    await dataSource.editNote(
      tDocumentationModel,
    );
    // assert
    verify(
      () => mockHttpClient.put(
        Uri.parse('$baseUrl/documentations/${tDocumentationModel.id}'),
        headers: {
          contentTypeHeader: 'application/x-www-form-urlencoded',
          authorizationHeader: 'Bearer token',
          appVersionHeader: '0.1.0'
        },
        body: tDocumentationModel.toForm(),
      ),
    );
  });

  test('should delete documentation', () async {
    // arrange
    when(() => mockPrefs.token).thenReturn('token');
    when(() => mockHttpClient.delete(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ))
        .thenAnswer((_) async =>
            http.Response(fixture('documentation/documentation.json'), 200));
    when(() => mockPackageInfo.version).thenReturn('0.1.0');
    // act
    await dataSource.delete(
      1,
    );
    // assert
    verify(
      () => mockHttpClient.delete(
        Uri.parse('$baseUrl/documentations/1'),
        headers: {
          contentTypeHeader: 'application/json',
          authorizationHeader: 'Bearer token',
          appVersionHeader: '0.1.0'
        },
      ),
    );
  });

  test('should post signature documentation multipart', () async {
    // arrange
    when(() => mockPrefs.token).thenReturn('Bearer token');
    when(() => mockPackageInfo.version).thenReturn('0.1.0');
    when(() => mockGeneralMultipartRequest.getMultipartRequest(
          method: any(named: 'method'),
          url: any(named: 'url'),
          headers: any(named: 'headers'),
          fields: any(named: 'fields'),
          files: any(named: 'files'),
        )).thenReturn(mockMultipartRequest);
    when(mockMultipartRequest.send).thenAnswer(
      (_) async => http.StreamedResponse(
        Stream.value(utf8.encode(fixture('documentation/documentation.json'))),
        200,
      ),
    );
    // act
    await dataSource.postSignatureMultipart(
      assignmentId: 1,
      title: 'John',
      uploadFile1Bytes: Uint8List(0),
      uploadFile2Bytes: Uint8List(0),
    );
    // assert
    verify(() => mockMultipartRequest.send());

    final capturedFields =
        verify(() => mockGeneralMultipartRequest.getMultipartRequest(
              method: any(named: 'method'),
              url: any(named: 'url'),
              headers: any(named: 'headers'),
              fields: captureAny(named: 'fields'),
              files: any(named: 'files'),
            )).captured.single as Map<String, dynamic>;

    expect(capturedFields['assignment_id'], equals('1'));
    expect(capturedFields['title'], equals('John'));
    expect(capturedFields['type'],
        equals(DocumentationType.signing.name.toUpperCase()));
  });

  test('should post image documentation multipart', () async {
    // arrange
    when(() => mockPrefs.token).thenReturn('Bearer token');
    when(() => mockPackageInfo.version).thenReturn('0.1.0');
    when(() => mockGeneralMultipartRequest.getMultipartRequest(
      method: any(named: 'method'),
      url: any(named: 'url'),
      headers: any(named: 'headers'),
      fields: any(named: 'fields'),
      files: any(named: 'files'),
    )).thenReturn(mockMultipartRequest);
    when(mockMultipartRequest.send).thenAnswer(
          (_) async => http.StreamedResponse(
        Stream.value(utf8.encode(fixture('documentation/documentation.json'))),
        200,
      ),
    );
    // act
    await dataSource.postImageMultipart(
      assignmentId: 1,
      title: 'John',
      image: Uint8List(0),
    );
    // assert
    verify(() => mockMultipartRequest.send());

    final capturedFields =
    verify(() => mockGeneralMultipartRequest.getMultipartRequest(
      method: any(named: 'method'),
      url: any(named: 'url'),
      headers: any(named: 'headers'),
      fields: captureAny(named: 'fields'),
      files: any(named: 'files'),
    )).captured.single as Map<String, dynamic>;

    expect(capturedFields['assignment_id'], equals('1'));
    expect(capturedFields['title'], equals('John'));
    expect(capturedFields['type'],
        equals(DocumentationType.photo.name.toUpperCase()));
  });
}
