import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/repositories/authentication_repository.dart';
import '../../../../../core/utils/assignments_utils.dart';
import '../../../../../core/utils/failure_helper.dart';
import '../../../domain/entities/assignments_data_holder.dart';
import '../../../domain/usecases/assignments/fetch_assignments.dart';
import '../../widgets/craftbox_slider.dart';

part 'assignments_event.dart';

part 'assignments_state.dart';

class AssignmentsBloc extends Bloc<AssignmentsEvent, AssignmentsState> {
  final FetchAssignments _fetchAssignments;
  final AuthenticationRepository _authenticationRepository;

  AssignmentsBloc({
    required FetchAssignments fetchAssignments,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _fetchAssignments = fetchAssignments,
        super(const AssignmentsState(assignments: [])) {
    on<AssignmentsFetched>(_onFetchAssignments);
    on<AssignmentsFilterTapped>(_onFilterTapped);
  }

  Future<void> _onFetchAssignments(
    AssignmentsFetched event,
    Emitter<AssignmentsState> emit,
  ) async {
    emit(state.copyWith(assignmentStatus: Status.loading));
    final sliderState = event.activeSegment;
    final failureOrSuccess = await _fetchAssignments(
      AssignmentsParams(
        withRelation: 'customer_address',
        isDataUpdateRequired: event.isDataUpdateRequired,
        activeSegment: sliderState,
        requestedStates: _buildAssignmentsStateList(state),
      ),
    );
    failureOrSuccess.fold(
      (failure) => emit(
        state.copyWith(
          assignmentStatus: Status.error,
          errorMessage: mapFailureToMessage(
            failure,
            onAuthenticationFailure: () async {
              await _authenticationRepository.unauthenticate();
              _fetchAssignments.clearAssignments();
            },
          ),
        ),
      ),
      (assignmentsDataHolder) => emit(
        state.copyWith(
          assignmentStatus: Status.loaded,
          assignments: assignmentsDataHolder.data,
          activeSegment: sliderState,
        ),
      ),
    );
  }

  List<OriginalAssignmentState> _buildAssignmentsStateList(
      AssignmentsState state) {
    final List<OriginalAssignmentState> stateList = [];

    for (final entry in state.filterStateMap.entries) {
      final isFilterChecked = entry.value;
      if (isFilterChecked) {
        stateList.add(entry.key.originalAssignmentState);
      }
    }

    return stateList;
  }

  Future<void> _onFilterTapped(
    AssignmentsFilterTapped event,
    Emitter<AssignmentsState> emit,
  ) async {
    final filter = event.state;
    final currentState = state;
    final Map<InAppAssignmentState, bool> updatedMap = {
      ...currentState.filterStateMap,
    }..update(filter, (value) => !value);
    final activeFilters =
        updatedMap.values.fold(0, (count, value) => count + (value ? 1 : 0));

    emit(currentState.copyWith(
      filterStateMap: updatedMap,
      activeFilters: activeFilters,
    ));

    await _onFetchAssignments(
      AssignmentsFetched(
        isDataUpdateRequired: false,
        activeSegment: state.activeSegment,
      ),
      emit,
    );
  }
}
