import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/features/assignments/domain/repositories/documentation_repository.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_time_documentation.dart';

class MockDocumentationRepository extends Mock
    implements DocumentationRepository {}

void main() {
  late MockDocumentationRepository mockDocumentationRepository;
  late CreateTimeDocumentation usecase;

  setUp(() {
    mockDocumentationRepository = MockDocumentationRepository();
    usecase = CreateTimeDocumentation(mockDocumentationRepository);
  });

  setUpAll(() {
    registerFallbackValue(const CreateTimeDocumentationParams(
      assignmentId: 1,
      workingTime: 0,
      breakTime: 0,
      drivingTime: 0,
      description: '',
      title: '',
    ));
  });

  test('should post documentation', () async {
    // arrange
    when(() {
      return mockDocumentationRepository.postTime(
          params: any(named: 'params'));
    }).thenAnswer((_) async => Left(InternetConnectionFailure()));
    // act
    await usecase(const CreateTimeDocumentationParams(
      assignmentId: 1,
      workingTime: 0,
      breakTime: 0,
      drivingTime: 0,
      description: '',
      title: '',
    ));
    // assert
    verify(() => mockDocumentationRepository.postTime(
        params: any(named: 'params')));
    verifyNoMoreInteractions(mockDocumentationRepository);
  });
}
