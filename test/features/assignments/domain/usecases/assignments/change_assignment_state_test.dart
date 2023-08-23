import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/utils/assignments_utils.dart';
import 'package:share/features/assignments/domain/entities/assignments_data_holder.dart';
import 'package:share/features/assignments/domain/repositories/assignments_repository.dart';
import 'package:share/features/assignments/domain/usecases/assignments/change_assignment_state.dart';

import '../../../../../core/utils.dart';

class MockAssignmentsRepository extends Mock implements AssignmentsRepository {}

void main() {
  late MockAssignmentsRepository mockAssignmentsRepository;
  late ChangeAssignmentState usecase;

  setUp(() {
    mockAssignmentsRepository = MockAssignmentsRepository();
    usecase = ChangeAssignmentState(mockAssignmentsRepository);
  });

  test('should change assignment state', () async {
    const tAssignmentId = 1;
    const tAssignmentState = InAppAssignmentState.paused;
    // arrange
    when(() {
      return mockAssignmentsRepository.putAssignmentState(
          assignmentId: tAssignmentId, stateToBeSet: tAssignmentState);
    }).thenAnswer((_) async => Right(SingleAssignmentHolder(
          data: getDummyAssignment(null),
        )));
    // act
    await usecase(const ChangeAssignmentStateParams(
      assignmentId: tAssignmentId,
      stateToBeSet: tAssignmentState,
    ));
    // assert
    verify(() => mockAssignmentsRepository.putAssignmentState(
        assignmentId: tAssignmentId, stateToBeSet: tAssignmentState));
    verifyNoMoreInteractions(mockAssignmentsRepository);
  });
}
