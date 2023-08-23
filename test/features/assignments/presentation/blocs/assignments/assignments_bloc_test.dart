import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/blocs/status.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/core/utils/assignments_utils.dart';
import 'package:share/features/assignments/domain/entities/assignments_data_holder.dart';
import 'package:share/features/assignments/domain/usecases/assignments/fetch_assignments.dart';
import 'package:share/features/assignments/presentation/blocs/assignments/assignments_bloc.dart';
import 'package:share/features/assignments/presentation/widgets/craftbox_slider.dart';
import 'package:share/generated/l10n.dart';

import '../../../../../core/utils.dart';

class MockFetchAssignments extends Mock implements FetchAssignments {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() async {
  await S.load(const Locale.fromSubtags(languageCode: 'en'));

  late MockFetchAssignments fetchAssignments;
  late MockAuthenticationRepository authenticationRepository;
  late AssignmentsBloc assignmentsBloc;

  setUpAll(() {
    registerFallbackValue(const AssignmentsParams(
      isDataUpdateRequired: false,
      withRelation: 'relation',
      activeSegment: ActiveSegment.past,
      requestedStates: [],
    ));
  });

  setUp(() {
    fetchAssignments = MockFetchAssignments();
    authenticationRepository = MockAuthenticationRepository();
    assignmentsBloc = AssignmentsBloc(
      fetchAssignments: fetchAssignments,
      authenticationRepository: authenticationRepository,
    );
  });

  test('initial logoutStatus should be LogoutStatus.initial', () {
    // assert
    expect(
      assignmentsBloc.state.assignmentStatus,
      equals(Status.initial),
    );
  });

  group('FetchAssignments', () {
    test(
        'should emit AssignmentStatus.loading and AssignmentStatus.loaded '
        'if fetchAssignments returned Right()', () async {
      final expectedHolder =
          AssignmentsListHolder(data: [getDummyAssignment(null)]);
      // arrange
      when(() => fetchAssignments(any()))
          .thenAnswer((_) async => Right(expectedHolder));
      // act
      assignmentsBloc.add(const AssignmentsFetched(
        isDataUpdateRequired: false,
        activeSegment: ActiveSegment.past,
      ));
      // assert
      final expectedOrder = [
        const AssignmentsState(
          assignmentStatus: Status.loading,
          assignments: [],
        ),
        AssignmentsState(
          assignmentStatus: Status.loaded,
          assignments: expectedHolder.data,
        ),
      ];
      await expectLater(assignmentsBloc.stream, emitsInOrder(expectedOrder));
      verify(() => fetchAssignments(const AssignmentsParams(
            withRelation: 'customer_address',
            isDataUpdateRequired: false,
            activeSegment: ActiveSegment.past,
            requestedStates: [],
          )));
      verifyNoMoreInteractions(fetchAssignments);
      verifyZeroInteractions(authenticationRepository);
    });

    test(
        'should emit AssignmentStatus.loading and AssignmentStatus.error '
        'if fetchAssignments returned Left()', () async {
      // arrange
      when(() => fetchAssignments(any()))
          .thenAnswer((_) async => Left(InternetConnectionFailure()));
      // act
      assignmentsBloc.add(const AssignmentsFetched(
        isDataUpdateRequired: false,
        activeSegment: ActiveSegment.past,
      ));
      // assert
      final expectedOrder = [
        const AssignmentsState(
          assignmentStatus: Status.loading,
          assignments: [],
        ),
        const AssignmentsState(
          assignmentStatus: Status.error,
          errorMessage: 'No internet connection',
          assignments: [],
        ),
      ];
      await expectLater(assignmentsBloc.stream, emitsInOrder(expectedOrder));
      verify(() => fetchAssignments(const AssignmentsParams(
            withRelation: 'customer_address',
            isDataUpdateRequired: false,
            activeSegment: ActiveSegment.past,
            requestedStates: [],
          )));
      verifyNoMoreInteractions(fetchAssignments);
      verifyZeroInteractions(authenticationRepository);
    });

    test(
        'should emit AssignmentStatus.loading with AssignmentStatus.error and '
        'call AuthenticationRepository if fetchAssignments '
        'returned Left(AuthorizationFailure())', () async {
      // arrange
      when(() => fetchAssignments(any()))
          .thenAnswer((_) async => Left(AuthorizationFailure()));
      when(() => authenticationRepository.unauthenticate())
          .thenAnswer((_) async => true);
      // act
      assignmentsBloc.add(const AssignmentsFetched(
        isDataUpdateRequired: false,
        activeSegment: ActiveSegment.past,
      ));
      // assert
      final expectedOrder = [
        const AssignmentsState(
          assignmentStatus: Status.loading,
          assignments: [],
        ),
        const AssignmentsState(
          assignmentStatus: Status.error,
          errorMessage: 'Session expired. Please login again.',
          assignments: [],
        ),
      ];
      await expectLater(assignmentsBloc.stream, emitsInOrder(expectedOrder));
      verify(() => authenticationRepository.unauthenticate());
      verify(() => fetchAssignments.clearAssignments());
      verify(() => fetchAssignments(const AssignmentsParams(
            withRelation: 'customer_address',
            isDataUpdateRequired: false,
            activeSegment: ActiveSegment.past,
            requestedStates: [],
          )));
      verifyNoMoreInteractions(fetchAssignments);
    });
  });

  group('AssignmentsFilterTapped', () {
    test(
        'should use AssignmentsParams with AssignmentState.scheduled '
        'if state is scheduled', () async {
      final expectedHolder =
          AssignmentsListHolder(data: [getDummyAssignment(null)]);
      // arrange
      when(() => fetchAssignments(any()))
          .thenAnswer((_) async => Right(expectedHolder));
      // act
      assignmentsBloc.add(const AssignmentsFilterTapped(
        state: InAppAssignmentState.scheduled,
      ));
      // assert
      const expectedStateMap = {
        InAppAssignmentState.scheduled: true,
        InAppAssignmentState.inProgress: false,
        InAppAssignmentState.paused: false,
        InAppAssignmentState.actionRequired: false,
        InAppAssignmentState.done: false,
      };
      final expectedOrder = [
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignments: [],
          activeFilters: 1,
        ),
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loading,
          assignments: [],
          activeFilters: 1,
        ),
        AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loaded,
          assignments: expectedHolder.data,
          activeFilters: 1,
        ),
      ];
      await expectLater(assignmentsBloc.stream, emitsInOrder(expectedOrder));
      verify(
        () => fetchAssignments(
          _getAssignmentsParams([OriginalAssignmentState.scheduled]),
        ),
      );
      verifyNoMoreInteractions(fetchAssignments);
    });

    test(
        'should use AssignmentsParams with AssignmentState.inProgress'
        ' if state is inProgress', () async {
      final expectedHolder =
          AssignmentsListHolder(data: [getDummyAssignment(null)]);
      // arrange
      when(() => fetchAssignments(any()))
          .thenAnswer((_) async => Right(expectedHolder));
      // act
      assignmentsBloc.add(const AssignmentsFilterTapped(
        state: InAppAssignmentState.inProgress,
      ));
      // assert
      const expectedStateMap = {
        InAppAssignmentState.scheduled: false,
        InAppAssignmentState.inProgress: true,
        InAppAssignmentState.paused: false,
        InAppAssignmentState.actionRequired: false,
        InAppAssignmentState.done: false,
      };
      final expectedOrder = [
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignments: [],
          activeFilters: 1,
        ),
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loading,
          assignments: [],
          activeFilters: 1,
        ),
        AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loaded,
          assignments: expectedHolder.data,
          activeFilters: 1,
        ),
      ];
      await expectLater(assignmentsBloc.stream, emitsInOrder(expectedOrder));
      verify(() => fetchAssignments(_getAssignmentsParams(
        [OriginalAssignmentState.inProgress],
          )));
      verifyNoMoreInteractions(fetchAssignments);
    });

    test(
        'should use AssignmentsParams with '
        ' AssignmentState.delayed if state is actionRequired', () async {
      final expectedHolder =
          AssignmentsListHolder(data: [getDummyAssignment(null)]);
      // arrange
      when(() => fetchAssignments(any()))
          .thenAnswer((_) async => Right(expectedHolder));
      // act
      assignmentsBloc.add(const AssignmentsFilterTapped(
        state: InAppAssignmentState.actionRequired,
      ));
      // assert
      const expectedStateMap = {
        InAppAssignmentState.scheduled: false,
        InAppAssignmentState.inProgress: false,
        InAppAssignmentState.paused: false,
        InAppAssignmentState.actionRequired: true,
        InAppAssignmentState.done: false,
      };
      final expectedOrder = [
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignments: [],
          activeFilters: 1,
        ),
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loading,
          assignments: [],
          activeFilters: 1,
        ),
        AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loaded,
          assignments: expectedHolder.data,
          activeFilters: 1,
        ),
      ];
      await expectLater(assignmentsBloc.stream, emitsInOrder(expectedOrder));
      verify(() => fetchAssignments(_getAssignmentsParams([
            OriginalAssignmentState.delayed,
          ])));
      verifyNoMoreInteractions(fetchAssignments);
    });

    test(
        'should use AssignmentsParams with '
        ' AssignmentState.paused if state is paused', () async {
      final expectedHolder =
          AssignmentsListHolder(data: [getDummyAssignment(null)]);
      // arrange
      when(() => fetchAssignments(any()))
          .thenAnswer((_) async => Right(expectedHolder));
      // act
      assignmentsBloc.add(const AssignmentsFilterTapped(
        state: InAppAssignmentState.paused,
      ));
      // assert
      const expectedStateMap = {
        InAppAssignmentState.scheduled: false,
        InAppAssignmentState.inProgress: false,
        InAppAssignmentState.paused: true,
        InAppAssignmentState.actionRequired: false,
        InAppAssignmentState.done: false,
      };
      final expectedOrder = [
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignments: [],
          activeFilters: 1,
        ),
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loading,
          assignments: [],
          activeFilters: 1,
        ),
        AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loaded,
          assignments: expectedHolder.data,
          activeFilters: 1,
        ),
      ];
      await expectLater(assignmentsBloc.stream, emitsInOrder(expectedOrder));
      verify(() => fetchAssignments(_getAssignmentsParams([
            OriginalAssignmentState.paused,
          ])));
      verifyNoMoreInteractions(fetchAssignments);
    });

    test(
        'should use AssignmentsParams with AssignmentState.done'
        ' if state is done', () async {
      final expectedHolder =
          AssignmentsListHolder(data: [getDummyAssignment(null)]);
      // arrange
      when(() => fetchAssignments(any()))
          .thenAnswer((_) async => Right(expectedHolder));
      // act
      assignmentsBloc.add(const AssignmentsFilterTapped(
        state: InAppAssignmentState.done,
      ));
      // assert
      const expectedStateMap = {
        InAppAssignmentState.scheduled: false,
        InAppAssignmentState.inProgress: false,
        InAppAssignmentState.paused: false,
        InAppAssignmentState.actionRequired: false,
        InAppAssignmentState.done: true,
      };
      final expectedOrder = [
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignments: [],
          activeFilters: 1,
        ),
        const AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loading,
          assignments: [],
          activeFilters: 1,
        ),
        AssignmentsState(
          filterStateMap: expectedStateMap,
          assignmentStatus: Status.loaded,
          assignments: expectedHolder.data,
          activeFilters: 1,
        ),
      ];
      await expectLater(assignmentsBloc.stream, emitsInOrder(expectedOrder));
      verify(() => fetchAssignments(
          _getAssignmentsParams([OriginalAssignmentState.done])));
      verifyNoMoreInteractions(fetchAssignments);
    });
  });
}

AssignmentsParams _getAssignmentsParams(List<OriginalAssignmentState> states) {
  return AssignmentsParams(
    withRelation: 'customer_address',
    isDataUpdateRequired: false,
    activeSegment: ActiveSegment.past,
    requestedStates: states,
  );
}
