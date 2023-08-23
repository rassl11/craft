part of 'assignments_bloc.dart';

class AssignmentsState extends Equatable {
  final Map<InAppAssignmentState, bool> filterStateMap;
  final String errorMessage;
  final List<Assignment> assignments;
  final ActiveSegment activeSegment;
  final Status assignmentStatus;
  final int activeFilters;

  const AssignmentsState({
    this.filterStateMap = const {
      InAppAssignmentState.scheduled: false,
      InAppAssignmentState.inProgress: false,
      InAppAssignmentState.paused: false,
      InAppAssignmentState.actionRequired: false,
      InAppAssignmentState.done: false,
    },
    this.errorMessage = '',
    this.activeFilters = 0,
    required this.assignments,
    this.activeSegment = ActiveSegment.past,
    this.assignmentStatus = Status.initial,
  });

  @override
  List<Object?> get props =>
      [
        filterStateMap,
        errorMessage,
        assignments,
        activeSegment,
        assignmentStatus,
        activeFilters
      ];

  AssignmentsState copyWith({
    Map<InAppAssignmentState, bool>? filterStateMap,
    String? errorMessage,
    List<Assignment>? assignments,
    ActiveSegment? activeSegment,
    Status? assignmentStatus,
    int? activeFilters,
  }) {
    return AssignmentsState(
      filterStateMap: filterStateMap ?? this.filterStateMap,
      errorMessage: errorMessage ?? this.errorMessage,
      assignments: assignments ?? this.assignments,
      activeSegment: activeSegment ?? this.activeSegment,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      activeFilters: activeFilters ?? this.activeFilters
    );
  }
}
