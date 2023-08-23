part of 'assignments_bloc.dart';

abstract class AssignmentsEvent extends Equatable {
  const AssignmentsEvent();
}

class AssignmentsFetched extends AssignmentsEvent {
  final bool isDataUpdateRequired;
  final ActiveSegment activeSegment;

  const AssignmentsFetched({
    required this.isDataUpdateRequired,
    required this.activeSegment,
  });

  @override
  List<Object?> get props => [activeSegment, isDataUpdateRequired];
}

class AssignmentsFilterTapped extends AssignmentsEvent {
  final InAppAssignmentState state;

  const AssignmentsFilterTapped({required this.state});

  @override
  List<Object?> get props => [state];
}
