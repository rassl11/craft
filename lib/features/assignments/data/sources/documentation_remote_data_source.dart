import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/shared_prefs.dart';
import '../../../../core/sources/base_remote_data_source.dart';
import '../../../../core/sources/craftbox_multipart_request.dart';
import '../../domain/entities/documentation.dart';
import '../models/documentation_model.dart';

abstract class DocumentationRemoteDataSource {
  Future<SingleDocumentationHolderModel> postTime(
    DocumentationModel documentationModel,
  );

  Future<SingleDocumentationHolderModel> editNote(
    DocumentationModel documentationModel,
  );

  Future<SingleDocumentationHolderModel> postNote(
    DocumentationModel documentationModel,
  );

  Future<SingleDocumentationHolderModel> postSignatureMultipart({
    required int assignmentId,
    required String title,
    required Uint8List uploadFile1Bytes,
    required Uint8List uploadFile2Bytes,
  });

  Future<SingleDocumentationHolderModel> postDraftMultipart({
    required int assignmentId,
    required String title,
    required Uint8List draft,
  });

  Future<SingleDocumentationHolderModel> postImageMultipart({
    required int assignmentId,
    required String title,
    required Uint8List image,
  });

  Future<dynamic> delete(
    int id,
  );
}

class DocumentationRemoteDataSourceImpl extends BaseRemoteDataSource
    implements DocumentationRemoteDataSource {
  final http.Client _client;
  final CraftboxMultipartRequest _multipartRequest;

  DocumentationRemoteDataSourceImpl({
    required http.Client client,
    required CraftboxMultipartRequest multipartRequest,
    required SharedPrefs sharedPrefs,
    required PackageInfo packageInfo,
  })  : _client = client,
        _multipartRequest = multipartRequest,
        super(
          sharedPrefs: sharedPrefs,
          packageInfo: packageInfo,
        );

  @override
  Future<SingleDocumentationHolderModel> postTime(
    DocumentationModel documentationModel,
  ) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/documentations'),
      headers: getHeaders(),
      body: jsonEncode(documentationModel.toJson()),
    );

    return SingleDocumentationHolderModel.fromJson(handleResponse(response));
  }

  @override
  Future<SingleDocumentationHolderModel> postNote(
    DocumentationModel documentationModel,
  ) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/documentations'),
      headers: getHeaders(contentType: ContentType.form),
      body: documentationModel.toForm(),
    );

    return SingleDocumentationHolderModel.fromJson(handleResponse(response));
  }

  @override
  Future<SingleDocumentationHolderModel> editNote(
    DocumentationModel documentationModel,
  ) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/documentations/${documentationModel.id}'),
      headers: getHeaders(contentType: ContentType.form),
      body: documentationModel.toForm(),
    );

    return SingleDocumentationHolderModel.fromJson(handleResponse(response));
  }

  @override
  Future<dynamic> delete(
    int id,
  ) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/documentations/$id'),
      headers: getHeaders(),
    );

    return handleResponse(response);
  }

  @override
  Future<SingleDocumentationHolderModel> postSignatureMultipart({
    required int assignmentId,
    required String title,
    required Uint8List uploadFile1Bytes,
    required Uint8List uploadFile2Bytes,
  }) async {
    final file1 = http.MultipartFile.fromBytes(
      uploadFile1,
      uploadFile1Bytes,
      contentType: MediaType.parse('image/png'),
      filename: '$title.png',
    );

    final file2 = http.MultipartFile.fromBytes(
      uploadFile2,
      uploadFile2Bytes,
      contentType: MediaType.parse('image/png'),
      filename: executorFilename,
    );

    final request = _multipartRequest.getMultipartRequest(
      method: 'POST',
      url: Uri.parse('$baseUrl/documentations'),
      headers: getHeaders(),
      fields: {
        'assignment_id': '$assignmentId',
        'type': DocumentationType.signing.name.toUpperCase(),
        'title': title,
        'documented_on': '${DateTime.now()}',
        'state': DocumentationStatus.acceptedWoComment.name,
      },
      files: [
        file1,
        file2,
      ],
    );

    final response = await http.Response.fromStream(await request.send());
    return SingleDocumentationHolderModel.fromJson(handleResponse(response));
  }

  @override
  Future<SingleDocumentationHolderModel> postDraftMultipart({
    required int assignmentId,
    required String title,
    required Uint8List draft,
  }) async {
    final file = http.MultipartFile.fromBytes(
      uploadFile1,
      draft,
      contentType: MediaType.parse('image/png'),
      filename: '$title.png',
    );

    final request = _multipartRequest.getMultipartRequest(
      method: 'POST',
      url: Uri.parse('$baseUrl/documentations'),
      headers: getHeaders(),
      fields: {
        'assignment_id': '$assignmentId',
        'type': DocumentationType.draft.name.toUpperCase(),
        'title': title,
        'documented_on': '${DateTime.now()}',
      },
      files: [
        file,
      ],
    );

    final response = await http.Response.fromStream(await request.send());
    return SingleDocumentationHolderModel.fromJson(handleResponse(response));
  }

  @override
  Future<SingleDocumentationHolderModel> postImageMultipart({
    required int assignmentId,
    required String title,
    required Uint8List image,
  }) async {
    final file = http.MultipartFile.fromBytes(
      uploadFile1,
      image,
      contentType: MediaType.parse('image/jpg'),
      filename: title,
    );

    final request = _multipartRequest.getMultipartRequest(
      method: 'POST',
      url: Uri.parse('$baseUrl/documentations'),
      headers: getHeaders(),
      fields: {
        'assignment_id': '$assignmentId',
        'type': DocumentationType.photo.name.toUpperCase(),
        'title': title,
        'documented_on': '${DateTime.now()}',
      },
      files: [
        file,
      ],
    );

    final response = await http.Response.fromStream(await request.send());
    return SingleDocumentationHolderModel.fromJson(handleResponse(response));
  }
}
