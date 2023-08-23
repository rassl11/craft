import '../../../presentation/widgets/craftbox_slider.dart';
import '../../entities/assignments_data_holder.dart';

class AssignmentsRefiner {
  List<Assignment> getFilteredAssignments({
    required List<Assignment> unfilteredAssignments,
    required ActiveSegment activeSegment,
    required List<OriginalAssignmentState> requestedStates,
  }) {
    final assignmentsFilteredByTime = unfilteredAssignments.where((assignment) {
      final assignmentStart = assignment.start;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (assignmentStart == null &&
          activeSegment == ActiveSegment.notScheduled) {
        return true;
      }

      if (assignmentStart != null &&
          activeSegment != ActiveSegment.notScheduled) {
        final assignmentStartDate = DateTime(
          assignmentStart.year,
          assignmentStart.month,
          assignmentStart.day,
        );
        switch (activeSegment) {
          case ActiveSegment.past:
            return assignmentStartDate.isBefore(today);
          case ActiveSegment.sinceToday:
            return assignmentStartDate == today ||
                assignmentStartDate.isAfter(today);
          default:
            return true;
        }
      }

      return false;
    }).toList();

    return _applyUserFilters(assignmentsFilteredByTime, requestedStates);
  }

  List<Assignment> _applyUserFilters(
    List<Assignment> assignmentsFilteredByTime,
    List<OriginalAssignmentState> requestedStates,
  ) {
    if (requestedStates.isNotEmpty) {
      return assignmentsFilteredByTime.where((assignment) {
        return requestedStates.contains(assignment.state);
      }).toList();
    } else {
      return assignmentsFilteredByTime;
    }
  }

  int compareAppointments(Assignment a, Assignment b) {
    final isAllDayA = a.isAllDay;
    final isAllDayB = b.isAllDay;
    final aStart = a.start;
    final bStart = b.start;
    if (isAllDayA != null && isAllDayB != null) {
      if (isAllDayA && isAllDayB) {
        if (aStart != null && bStart != null) {
          return aStart.compareTo(bStart);
        }
      } else if (!isAllDayA && !isAllDayB) {
        if (aStart != null && bStart != null) {
          return aStart.compareTo(bStart);
        }
      }
    }

    return 0;
  }
}
