import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/features/assignments/domain/entities/assignments_data_holder.dart';
import 'package:share/features/assignments/domain/repositories/assignments_repository.dart';
import 'package:share/features/assignments/domain/usecases/assignments/assignments_refiner.dart';
import 'package:share/features/assignments/domain/usecases/assignments/fetch_assignments.dart';
import 'package:share/features/assignments/presentation/widgets/craftbox_slider.dart';

import '../../../../../core/utils.dart';

class MockAssignmentsRepository extends Mock implements AssignmentsRepository {}

class MockAssignmentsUtils extends Mock implements AssignmentsRefiner {}

void main() {
  late FetchAssignments useCase;
  late MockAssignmentsRepository mockAssignmentsRepository;
  late MockAssignmentsUtils mockAssignmentsUtils;

  setUpAll(() {
    registerFallbackValue(getDummyAssignment(null));
  });

  setUp(() {
    mockAssignmentsRepository = MockAssignmentsRepository();
    mockAssignmentsUtils = MockAssignmentsUtils();
    useCase = FetchAssignments(mockAssignmentsRepository, mockAssignmentsUtils);
  });

  test(
    'should fetch available assignments if _assignments.isEmpty',
    () async {
      const tParams = AssignmentsParams(
        isDataUpdateRequired: false,
        withRelation: 'relation',
        activeSegment: ActiveSegment.past,
        requestedStates: [],
      );
      // arrange
      when(() => mockAssignmentsRepository.fetchAssignments(
              withRelation: tParams.withRelation))
          .thenAnswer((_) async => Future.value(Left(AuthorizationFailure())));
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, Left(AuthorizationFailure()));
      verify(() => mockAssignmentsRepository.fetchAssignments(
          withRelation: tParams.withRelation));
      verifyZeroInteractions(mockAssignmentsUtils);
      verifyNoMoreInteractions(mockAssignmentsRepository);
    },
  );

  test(
    'should fetch available assignments if _assignments.isNotEmpty but '
    'isDataUpdateRequired is true',
    () async {
      const tParams = AssignmentsParams(
        isDataUpdateRequired: true,
        withRelation: 'relation',
        activeSegment: ActiveSegment.past,
        requestedStates: [],
      );
      // arrange
      useCase.assignments = [getDummyAssignment(null)];
      when(() => mockAssignmentsRepository.fetchAssignments(
                withRelation: tParams.withRelation,
              ))
          .thenAnswer((_) async => Future.value(Left(AuthorizationFailure())));
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, Left(AuthorizationFailure()));
      verify(() => mockAssignmentsRepository.fetchAssignments(
            withRelation: tParams.withRelation,
          ));
      verifyZeroInteractions(mockAssignmentsUtils);
      verifyNoMoreInteractions(mockAssignmentsRepository);
    },
  );

  test(
    'should refine assignments if _assignments.isNotEmpty',
    () async {
      const tParams = AssignmentsParams(
        isDataUpdateRequired: false,
        withRelation: 'relation',
        activeSegment: ActiveSegment.past,
        requestedStates: [],
      );
      final tAssignments = [getDummyAssignment(null), getDummyAssignment(null)];
      final tRightResult = AssignmentsListHolder(data: tAssignments);
      // arrange
      useCase.assignments = tAssignments;
      when(() => mockAssignmentsUtils.getFilteredAssignments(
            unfilteredAssignments: useCase.assignments,
            activeSegment: tParams.activeSegment,
            requestedStates: tParams.requestedStates,
          )).thenReturn(tAssignments);
      when(() => mockAssignmentsUtils.compareAppointments(any(), any()))
          .thenReturn(0);
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, Right(tRightResult));
      verify(() => mockAssignmentsUtils.getFilteredAssignments(
            unfilteredAssignments: useCase.assignments,
            activeSegment: tParams.activeSegment,
            requestedStates: tParams.requestedStates,
          ));
      verify(() => mockAssignmentsUtils.compareAppointments(any(), any()));
      verifyZeroInteractions(mockAssignmentsRepository);
    },
  );
}
