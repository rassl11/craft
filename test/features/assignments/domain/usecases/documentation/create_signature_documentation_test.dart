import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/repositories/documentation_repository.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_signature_documentation.dart';

import '../../../../../core/utils.dart';

class MockDocumentationRepository extends Mock
    implements DocumentationRepository {}

void main() {
  late MockDocumentationRepository mockDocumentationRepository;
  late CreateSignatureDocumentation usecase;

  setUp(() {
    mockDocumentationRepository = MockDocumentationRepository();
    usecase = CreateSignatureDocumentation(mockDocumentationRepository);
  });

  setUpAll(() {
    registerFallbackValue(CreateSignatureDocumentationParams(
      assignmentId: 1,
      title: '',
      uploadFile1: Uint8List(0),
      uploadFile2: Uint8List(0),
    ));
  });

  test('should post signature documentation', () async {
    // arrange
    when(() {
      return mockDocumentationRepository.postSignature(
          params: any(named: 'params'));
    }).thenAnswer((_) async => Right(SingleDocumentationHolder(
          documentation: getDummyDocumentation(),
        )));
    // act
    final params = CreateSignatureDocumentationParams(
      assignmentId: 1,
      title: '',
      uploadFile1: Uint8List(0),
      uploadFile2: Uint8List(0),
    );
    await usecase(params);
    // assert
    verify(() => mockDocumentationRepository.postSignature(
          params: params,
        ));
    verifyNoMoreInteractions(mockDocumentationRepository);
  });
}
