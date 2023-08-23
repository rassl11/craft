import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/network/network_info.dart';
import 'package:share/features/assignments/data/models/documentation_model.dart';
import 'package:share/features/assignments/data/repositories/documentation_repository_impl.dart';
import 'package:share/features/assignments/data/sources/documentation_remote_data_source.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_image_documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_note_documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_signature_documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_time_documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/delete_documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/edit_note_documentation.dart';

class MockDocumentationRemoteDataSource extends Mock
    implements DocumentationRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late DocumentationRepositoryImpl repository;
  late DocumentationRemoteDataSource dataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    dataSource = MockDocumentationRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = DocumentationRepositoryImpl(
      remoteDataSource: dataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('postDocumentation', () {
    test('should check network and call remoteDataSource.postDocumentation',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.postTime(
        params: const CreateTimeDocumentationParams(
          assignmentId: 1,
          workingTime: 1,
          breakTime: 1,
          drivingTime: 1,
          title: 'title',
          description: 'description',
        ),
      );
      // assert
      verify(
        () => dataSource.postTime(
          const DocumentationModel.postTime(
            assignmentId: 1,
            workingTime: 1,
            breakTime: 1,
            drivingTime: 1,
            type: DocumentationType.time,
            title: 'title',
            description: 'description',
          ),
        ),
      );
    });

    test('should check network and call remoteDataSource.postNoteDocumentation',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.postNote(
        params: const CreateNoteDocumentationParams(
          assignmentId: 1,
          title: 'title',
          description: 'description',
        ),
      );
      // assert
      verify(
        () => dataSource.postNote(
          const DocumentationModel.postNote(
            assignmentId: 1,
            type: DocumentationType.note,
            title: 'title',
            description: 'description',
          ),
        ),
      );
    });

    test('should check network and call remoteDataSource.editNoteDocumentation',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.editNote(
        params: const EditNoteDocumentationParams(
          assignmentId: 1,
          documentationId: 1,
          title: 'title',
          description: 'description',
        ),
      );
      // assert
      verify(
        () => dataSource.editNote(
          const DocumentationModel.postEditNote(
            id: 1,
            assignmentId: 1,
            type: DocumentationType.note,
            title: 'title',
            description: 'description',
          ),
        ),
      );
    });

    test('should check network and call remoteDataSource.deleteDocumentation',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.delete(
        params: const DeleteDocumentationParams(
          id: 1,
        ),
      );
      // assert
      verify(
        () => dataSource.delete(
          1,
        ),
      );
    });

    test(
        'should check network and call remoteDataSource.postSignatureMultipart',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.postSignature(
        params: CreateSignatureDocumentationParams(
          assignmentId: 1,
          title: 'John',
          uploadFile1: Uint8List(0),
          uploadFile2: Uint8List(0),
        ),
      );
      // assert
      verify(
        () => dataSource.postSignatureMultipart(
          assignmentId: 1,
          title: 'John',
          uploadFile1Bytes: Uint8List(0),
          uploadFile2Bytes: Uint8List(0),
        ),
      );
    });

    test('should check network and call remoteDataSource.postImageMultipart',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.postImage(
        params: CreateImageDocumentationParams(
          assignmentId: 1,
          title: 'John',
          image: Uint8List(0),
        ),
      );
      // assert
      verify(
        () => dataSource.postImageMultipart(
          assignmentId: 1,
          title: 'John',
          image: Uint8List(0),
        ),
      );
    });
  });
}
