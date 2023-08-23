part of 'detailed_assignment_bloc.dart';

abstract class DetailedAssignmentEvent extends Equatable {
  const DetailedAssignmentEvent();
}

class DetailedAssignmentFetched extends DetailedAssignmentEvent {
  final int assignmentId;

  const DetailedAssignmentFetched({required this.assignmentId});

  @override
  List<Object?> get props => [assignmentId];
}

class AssignmentStatusSelected extends DetailedAssignmentEvent {
  final int assignmentId;
  final InAppAssignmentState selectedAssignmentState;

  const AssignmentStatusSelected({
    required this.assignmentId,
    required this.selectedAssignmentState,
  });

  @override
  List<Object?> get props => [assignmentId, selectedAssignmentState];
}
