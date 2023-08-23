import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/features/assignments/domain/repositories/assignments_repository.dart';
import 'package:share/features/assignments/domain/usecases/assignments/fetch_detailed_assignment.dart';

class MockAssignmentsRepository extends Mock implements AssignmentsRepository {}

void main() {
  late MockAssignmentsRepository mockAssignmentsRepository;
  late FetchDetailedAssignment usecase;

  setUp(() {
    mockAssignmentsRepository = MockAssignmentsRepository();
    usecase = FetchDetailedAssignment(mockAssignmentsRepository);
  });

  test('should get detailed assignment from the repository', () async {
    // arrange
    const tAssignmentId = 1;
    when(() {
      return mockAssignmentsRepository.fetchDetailedAssignment(
          assignmentId: tAssignmentId);
    }).thenAnswer((_) async => const Left(ServerFailure()));
    // act
    await usecase(const DetailedAssignmentParams(1));
    // assert
    verify(() =>
        mockAssignmentsRepository.fetchDetailedAssignment(assignmentId: 1));
    verifyNoMoreInteractions(mockAssignmentsRepository);
  });
}
