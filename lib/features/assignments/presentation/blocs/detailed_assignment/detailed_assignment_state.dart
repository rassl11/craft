part of 'detailed_assignment_bloc.dart';

class DetailedAssignmentState extends Equatable {
  final RecordedTime totalTimeHolder;
  final Status blocStatus;
  final String errorMsg;
  final Assignment? assignment;
  final InAppAssignmentState? selectedAssignmentState;
  final Status assignmentSelectionStatus;
  final bool isSigned;

  const DetailedAssignmentState({
    this.totalTimeHolder = const RecordedTime(),
    this.blocStatus = Status.initial,
    this.errorMsg = '',
    this.assignment,
    this.selectedAssignmentState,
    this.assignmentSelectionStatus = Status.initial,
    this.isSigned = false,
  });

  @override
  List<Object?> get props => [
        totalTimeHolder,
        blocStatus,
        errorMsg,
        assignment,
        selectedAssignmentState,
        assignmentSelectionStatus,
        isSigned,
      ];

  DetailedAssignmentState copyWith({
    RecordedTime? totalTimeHolder,
    Status? blocStatus,
    String? errorMsg,
    Assignment? assignment,
    InAppAssignmentState? selectedAssignmentState,
    Status? assignmentSelectionStatus,
    bool? isSigned,
  }) {
    return DetailedAssignmentState(
      totalTimeHolder: totalTimeHolder ?? this.totalTimeHolder,
      blocStatus: blocStatus ?? this.blocStatus,
      errorMsg: errorMsg ?? this.errorMsg,
      assignment: assignment ?? this.assignment,
      selectedAssignmentState:
          selectedAssignmentState ?? this.selectedAssignmentState,
      assignmentSelectionStatus:
          assignmentSelectionStatus ?? this.assignmentSelectionStatus,
      isSigned: isSigned ?? this.isSigned,
    );
  }
}
