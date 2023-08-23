import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/repositories/documentation_repository.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_note_documentation.dart';

import '../../../../../core/utils.dart';

class MockDocumentationRepository extends Mock
    implements DocumentationRepository {}

void main() {
  late MockDocumentationRepository mockDocumentationRepository;
  late CreateNoteDocumentation usecase;

  setUp(() {
    mockDocumentationRepository = MockDocumentationRepository();
    usecase = CreateNoteDocumentation(mockDocumentationRepository);
  });

  setUpAll(() {
    registerFallbackValue(const CreateNoteDocumentationParams(
      assignmentId: 1,
      description: '',
      title: '',
    ));
  });

  test('should post note documentation', () async {
    // arrange
    when(() {
      return mockDocumentationRepository.postNote(
          params: any(named: 'params'));
    }).thenAnswer((_) async => Right(SingleDocumentationHolder(
          documentation: getDummyDocumentation(),
        )));
    // act
    const params = CreateNoteDocumentationParams(
      assignmentId: 1,
      description: 'text',
      title: 'title',
    );
    await usecase(params);
    // assert
    verify(() => mockDocumentationRepository.postNote(
        params: params,));
    verifyNoMoreInteractions(mockDocumentationRepository);
  });
}
