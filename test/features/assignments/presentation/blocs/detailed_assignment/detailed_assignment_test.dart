import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/blocs/status.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/core/utils/assignments_utils.dart';
import 'package:share/features/assignments/domain/entities/assignments_data_holder.dart';
import 'package:share/features/assignments/domain/usecases/assignments/change_assignment_state.dart';
import 'package:share/features/assignments/domain/usecases/assignments/fetch_detailed_assignment.dart';
import 'package:share/features/assignments/presentation/blocs/detailed_assignment/detailed_assignment_bloc.dart';
import 'package:share/generated/l10n.dart';

import '../../../../../core/utils.dart';

class MockFetchDetailedAssignment extends Mock
    implements FetchDetailedAssignment {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockChangeAssignmentState extends Mock implements ChangeAssignmentState {}

void main() async {
  await S.load(const Locale.fromSubtags(languageCode: 'en'));

  late MockFetchDetailedAssignment fetchDetailedAssignment;
  late MockAuthenticationRepository authenticationRepository;
  late MockChangeAssignmentState changeAssignmentState;
  late DetailedAssignmentBloc detailedAssignmentBloc;

  setUpAll(() {
    registerFallbackValue(const DetailedAssignmentParams(1));
  });

  setUp(() {
    fetchDetailedAssignment = MockFetchDetailedAssignment();
    authenticationRepository = MockAuthenticationRepository();
    changeAssignmentState = MockChangeAssignmentState();
    detailedAssignmentBloc = DetailedAssignmentBloc(
      fetchDetailedAssignment: fetchDetailedAssignment,
      authenticationRepository: authenticationRepository,
      changeAssignmentState: changeAssignmentState,
    );
  });

  test('initial state should be DetailedAssignmentState', () {
    // assert
    expect(
      detailedAssignmentBloc.state,
      equals(const DetailedAssignmentState()),
    );
  });

  group('FetchDetailedAssignment', () {
    const tAssignmentId = 1;
    const tParams = DetailedAssignmentParams(tAssignmentId);

    test(
        'should emit DetailedAssignmentLoading and DetailedAssignmentLoaded '
        'if fetchDetailedAssignment returned Right()', () async {
      final expectedAssignment = getDummyAssignment(null, documentations: [
        getDummyDocumentation(),
      ]);
      final expectedHolder = SingleAssignmentHolder(
        data: expectedAssignment,
      );

      // arrange
      when(() => fetchDetailedAssignment(tParams))
          .thenAnswer((_) async => Right(expectedHolder));
      // act
      detailedAssignmentBloc.add(
        const DetailedAssignmentFetched(assignmentId: tAssignmentId),
      );
      // assert
      final expectedOrder = [
        const DetailedAssignmentState(blocStatus: Status.loading),
        DetailedAssignmentState(
          blocStatus: Status.loaded,
          assignment: expectedAssignment,
        ),
      ];
      await expectLater(
        detailedAssignmentBloc.stream,
        emitsInOrder(expectedOrder),
      );
      verify(() => fetchDetailedAssignment(tParams));
      verifyZeroInteractions(authenticationRepository);
    });

    test(
        'should emit DetailedAssignmentLoading and DetailedAssignmentError '
            'if fetchDetailedAssignment returned Left()', () async {
      // arrange
      when(() => fetchDetailedAssignment(any()))
          .thenAnswer((_) async => Left(InternetConnectionFailure()));
      // act
      detailedAssignmentBloc.add(
        const DetailedAssignmentFetched(assignmentId: tAssignmentId),
      );
      // assert
      final expectedOrder = [
        const DetailedAssignmentState(blocStatus: Status.loading),
        const DetailedAssignmentState(
          blocStatus: Status.error,
          errorMsg: 'No internet connection',
        ),
      ];
      await expectLater(
        detailedAssignmentBloc.stream,
        emitsInOrder(expectedOrder),
      );
    });

    test(
        'should emit DetailedAssignmentLoading and DetailedAssignmentError '
            'if fetchDetailedAssignment returned Left(AuthorizationFailure())',
            () async {
          // arrange
          when(() => fetchDetailedAssignment(any()))
          .thenAnswer((_) async => Left(AuthorizationFailure()));
      when(() => authenticationRepository.unauthenticate())
          .thenAnswer((_) async => true);
      // act
      detailedAssignmentBloc.add(
        const DetailedAssignmentFetched(assignmentId: tAssignmentId),
      );
      // assert
      final expectedOrder = [
        const DetailedAssignmentState(blocStatus: Status.loading),
        const DetailedAssignmentState(
          blocStatus: Status.error,
          errorMsg: 'Session expired. Please login again.',
        ),
      ];
      await expectLater(
        detailedAssignmentBloc.stream,
        emitsInOrder(expectedOrder),
      );
      verify(() => authenticationRepository.unauthenticate());
        });
  });

  group('AssignmentStatusSelected', () {
    const tAssignmentId = 1;
    const tDetailedAssignmentParams = DetailedAssignmentParams(tAssignmentId);
    const tSelectedState = InAppAssignmentState.actionRequired;
    const tChangeStateParams = ChangeAssignmentStateParams(
      assignmentId: tAssignmentId,
      stateToBeSet: tSelectedState,
    );
    final expectedAssignment = getDummyAssignment(null);
    final expectedHolder = SingleAssignmentHolder(
      data: expectedAssignment,
    );
    blocTest<DetailedAssignmentBloc, DetailedAssignmentState>(
      'should set new status and request a new(updated) assignment',
      setUp: () {
        when(() => fetchDetailedAssignment(tDetailedAssignmentParams))
            .thenAnswer((_) async => Right(expectedHolder));
        when(() => changeAssignmentState(tChangeStateParams))
            .thenAnswer((_) async => Right(expectedHolder));
      },
      seed: () => DetailedAssignmentState(
        blocStatus: Status.loaded,
        assignment: expectedAssignment,
      ),
      act: (bloc) => bloc.add(
        const AssignmentStatusSelected(
          assignmentId: tAssignmentId,
          selectedAssignmentState: tSelectedState,
        ),
      ),
      build: () => DetailedAssignmentBloc(
        fetchDetailedAssignment: fetchDetailedAssignment,
        authenticationRepository: authenticationRepository,
        changeAssignmentState: changeAssignmentState,
      ),
      expect: () => <DetailedAssignmentState>[
        DetailedAssignmentState(
          blocStatus: Status.loaded,
          assignmentSelectionStatus: Status.loading,
          selectedAssignmentState: tSelectedState,
          assignment: expectedAssignment,
        ),
        DetailedAssignmentState(
          blocStatus: Status.loaded,
          assignmentSelectionStatus: Status.loaded,
          assignment: expectedAssignment,
          selectedAssignmentState: tSelectedState,
        )
      ],
    );

    blocTest<DetailedAssignmentBloc, DetailedAssignmentState>(
      'should call authenticationRepository.unauthenticate() and emit status '
          'error if changeAssignmentState returned Left()',
      setUp: () {
        when(() => fetchDetailedAssignment(tDetailedAssignmentParams))
            .thenAnswer((_) async => Right(expectedHolder));
        when(() => changeAssignmentState(tChangeStateParams))
            .thenAnswer((_) async => Left(AuthorizationFailure()));
        when(() => authenticationRepository.unauthenticate())
            .thenAnswer((_) async => true);
      },
      seed: () => DetailedAssignmentState(
        blocStatus: Status.loaded,
        assignment: expectedAssignment,
      ),
      act: (bloc) => bloc.add(
        const AssignmentStatusSelected(
          assignmentId: tAssignmentId,
          selectedAssignmentState: tSelectedState,
        ),
      ),
      build: () => DetailedAssignmentBloc(
        fetchDetailedAssignment: fetchDetailedAssignment,
        authenticationRepository: authenticationRepository,
        changeAssignmentState: changeAssignmentState,
      ),
      expect: () => <DetailedAssignmentState>[
        DetailedAssignmentState(
          blocStatus: Status.loaded,
          assignmentSelectionStatus: Status.loading,
          selectedAssignmentState: tSelectedState,
          assignment: expectedAssignment,
        ),
        DetailedAssignmentState(
          blocStatus: Status.loaded,
          assignmentSelectionStatus: Status.error,
          assignment: expectedAssignment,
          errorMsg: 'Session expired. Please login again.',
          selectedAssignmentState: expectedAssignment.state.inAppState,
        )
      ],
      verify: (_) {
        verify(() => authenticationRepository.unauthenticate());
      },
    );

    blocTest<DetailedAssignmentBloc, DetailedAssignmentState>(
      'should skip state changing if changeAssignmentState = Status.loading',
      setUp: () {
        when(() => fetchDetailedAssignment(tDetailedAssignmentParams))
            .thenAnswer((_) async => Right(expectedHolder));
        when(() => changeAssignmentState(tChangeStateParams))
            .thenAnswer((_) async => Right(expectedHolder));
      },
      seed: () => DetailedAssignmentState(
        blocStatus: Status.loaded,
        assignment: expectedAssignment,
        assignmentSelectionStatus: Status.loading,
      ),
      act: (bloc) => bloc.add(
        const AssignmentStatusSelected(
          assignmentId: tAssignmentId,
          selectedAssignmentState: tSelectedState,
        ),
      ),
      build: () => DetailedAssignmentBloc(
        fetchDetailedAssignment: fetchDetailedAssignment,
        authenticationRepository: authenticationRepository,
        changeAssignmentState: changeAssignmentState,
      ),
      verify: (_) {
        verifyNever(() => changeAssignmentState(tChangeStateParams));
      },
    );
  });
}
