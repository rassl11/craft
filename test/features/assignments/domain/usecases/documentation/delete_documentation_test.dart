import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/features/assignments/domain/repositories/documentation_repository.dart';
import 'package:share/features/assignments/domain/usecases/documentation/delete_documentation.dart';

class MockDocumentationRepository extends Mock
    implements DocumentationRepository {}

void main() {
  late MockDocumentationRepository mockDocumentationRepository;
  late DeleteDocumentation usecase;

  setUp(() {
    mockDocumentationRepository = MockDocumentationRepository();
    usecase = DeleteDocumentation(mockDocumentationRepository);
  });

  setUpAll(() {
    registerFallbackValue(const DeleteDocumentationParams(
      id: 1,
    ));
  });

  test('should post note documentation', () async {
    // arrange
    when(() {
      return mockDocumentationRepository.delete(params: any(named: 'params'));
    }).thenAnswer((_) async => const Right(null));
    // act
    const params = DeleteDocumentationParams(id: 1);
    await usecase(params);
    // assert
    verify(() => mockDocumentationRepository.delete(
          params: params,
        ));
    verifyNoMoreInteractions(mockDocumentationRepository);
  });
}
