import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/repositories/authentication_repository.dart';
import '../../../../../core/utils/assignments_utils.dart';
import '../../../../../core/utils/failure_helper.dart';
import '../../../domain/entities/assignments_data_holder.dart';
import '../../../domain/entities/documentation.dart';
import '../../../domain/entities/recorded_time.dart';
import '../../../domain/usecases/assignments/change_assignment_state.dart';
import '../../../domain/usecases/assignments/fetch_detailed_assignment.dart';

part 'detailed_assignment_event.dart';
part 'detailed_assignment_state.dart';

class DetailedAssignmentBloc
    extends Bloc<DetailedAssignmentEvent, DetailedAssignmentState> {
  final FetchDetailedAssignment _fetchDetailedAssignment;
  final AuthenticationRepository _authenticationRepository;
  final ChangeAssignmentState _changeAssignmentState;

  DetailedAssignmentBloc({
    required FetchDetailedAssignment fetchDetailedAssignment,
    required AuthenticationRepository authenticationRepository,
    required ChangeAssignmentState changeAssignmentState,
  })  : _changeAssignmentState = changeAssignmentState,
        _authenticationRepository = authenticationRepository,
        _fetchDetailedAssignment = fetchDetailedAssignment,
        super(const DetailedAssignmentState()) {
    on<DetailedAssignmentFetched>(_onDetailedAssignmentFetched);
    on<AssignmentStatusSelected>(_onAssignmentStatusSelected);
  }

  Future<void> _onDetailedAssignmentFetched(
    DetailedAssignmentFetched event,
    Emitter<DetailedAssignmentState> emit,
  ) async {
    if (state.assignmentSelectionStatus != Status.loading) {
      emit(state.copyWith(blocStatus: Status.loading));
    }

    final result = await _fetchDetailedAssignment(
      DetailedAssignmentParams(event.assignmentId),
    );
    result.fold(
      (failure) {
        _handleError(emit, failure);
      },
      (data) {
        _handleRequestResult(emit, data);
      },
    );
  }

  void _handleError(Emitter<DetailedAssignmentState> emit, Failure failure) {
    return emit(
      state.copyWith(
        blocStatus: Status.error,
        errorMsg: mapFailureToMessage(
          failure,
          onAuthenticationFailure: () async {
            await _authenticationRepository.unauthenticate();
          },
        ),
      ),
    );
  }

  void _handleRequestResult(
    Emitter<DetailedAssignmentState> emit,
    SingleAssignmentHolder data,
  ) {
    final assignment = data.data;
    final documentations = assignment.documentations;
    final isSigned = documentations
        .any((element) => element.type == DocumentationType.signing);

    if (state.assignmentSelectionStatus == Status.loading) {
      emit(
        state.copyWith(
          blocStatus: Status.loaded,
          assignment: assignment,
          totalTimeHolder: _getTotalRecordedTime(assignment.documentations),
          assignmentSelectionStatus: Status.loaded,
          isSigned: isSigned,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        blocStatus: Status.loaded,
        totalTimeHolder: _getTotalRecordedTime(assignment.documentations),
        assignment: assignment,
        isSigned: isSigned,
      ),
    );
  }

  RecordedTime _getTotalRecordedTime(
    final List<Documentation>? documentations,
  ) {
    if (documentations == null) {
      return const RecordedTime();
    }

    int workingTime = 0;
    int breakTime = 0;
    int drivingTime = 0;
    for (final element in documentations) {
      workingTime += element.workingTime ?? 0;
      breakTime += element.breakTime ?? 0;
      drivingTime += element.drivingTime ?? 0;
    }

    return RecordedTime(
      workingTime: workingTime,
      breakTime: breakTime,
      drivingTime: drivingTime,
    );
  }

  Future<void> _onAssignmentStatusSelected(
    AssignmentStatusSelected event,
    Emitter<DetailedAssignmentState> emit,
  ) async {
    if (state.assignmentSelectionStatus == Status.loading) {
      return;
    }

    emit(
      state.copyWith(
        assignmentSelectionStatus: Status.loading,
        selectedAssignmentState: event.selectedAssignmentState,
      ),
    );

    final result = await _changeAssignmentState(
      ChangeAssignmentStateParams(
        assignmentId: event.assignmentId,
        stateToBeSet: event.selectedAssignmentState,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          assignmentSelectionStatus: Status.error,
          selectedAssignmentState: state.assignment?.state.inAppState,
          errorMsg: mapFailureToMessage(
            failure,
            onAuthenticationFailure: () async {
              await _authenticationRepository.unauthenticate();
            },
          ),
        ),
      ),
      (data) {
        add(DetailedAssignmentFetched(
          assignmentId: event.assignmentId,
        ));
      },
    );
  }
}
