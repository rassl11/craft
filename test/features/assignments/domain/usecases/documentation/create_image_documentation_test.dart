import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/repositories/documentation_repository.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_image_documentation.dart';

import '../../../../../core/utils.dart';

class MockDocumentationRepository extends Mock
    implements DocumentationRepository {}

void main() {
  late MockDocumentationRepository mockDocumentationRepository;
  late CreateImageDocumentation usecase;

  setUp(() {
    mockDocumentationRepository = MockDocumentationRepository();
    usecase = CreateImageDocumentation(mockDocumentationRepository);
  });

  setUpAll(() {
    registerFallbackValue(CreateImageDocumentationParams(
      assignmentId: 1,
      image: Uint8List(0),
      title: '',
    ));
  });

  test('should post image documentation', () async {
    // arrange
    when(() {
      return mockDocumentationRepository.postImage(
          params: any(named: 'params'));
    }).thenAnswer((_) async => Right(SingleDocumentationHolder(
          documentation: getDummyDocumentation(),
        )));
    // act
    final params = CreateImageDocumentationParams(
      assignmentId: 1,
      image: Uint8List(0),
      title: 'title',
    );
    await usecase(params);
    // assert
    verify(() => mockDocumentationRepository.postImage(
        params: params,));
    verifyNoMoreInteractions(mockDocumentationRepository);
  });
}
