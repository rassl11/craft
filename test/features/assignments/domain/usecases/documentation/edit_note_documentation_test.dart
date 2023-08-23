import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/repositories/documentation_repository.dart';
import 'package:share/features/assignments/domain/usecases/documentation/edit_note_documentation.dart';

import '../../../../../core/utils.dart';

class MockDocumentationRepository extends Mock
    implements DocumentationRepository {}

void main() {
  late MockDocumentationRepository mockDocumentationRepository;
  late EditNoteDocumentation usecase;

  setUp(() {
    mockDocumentationRepository = MockDocumentationRepository();
    usecase = EditNoteDocumentation(mockDocumentationRepository);
  });

  setUpAll(() {
    registerFallbackValue(const EditNoteDocumentationParams(
      assignmentId: 1,
      documentationId: 1,
      description: '',
      title: '',
    ));
  });

  test('should post note documentation', () async {
    // arrange
    when(() {
      return mockDocumentationRepository.editNote(params: any(named: 'params'));
    }).thenAnswer((_) async => Right(SingleDocumentationHolder(
          documentation: getDummyDocumentation(),
        )));
    // act
    const params = EditNoteDocumentationParams(
      assignmentId: 1,
      documentationId: 1,
      description: 'text',
      title: 'title',
    );
    await usecase(params);
    // assert
    verify(() => mockDocumentationRepository.editNote(
          params: params,
        ));
    verifyNoMoreInteractions(mockDocumentationRepository);
  });
}
