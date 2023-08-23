import 'package:equatable/equatable.dart';

import '../../../../core/utils/assignments_utils.dart';
import 'article.dart';
import 'creation.dart';
import 'customer_data_holder.dart';
import 'document.dart';
import 'documentation.dart';
import 'employee.dart';
import 'project.dart';
import 'tag.dart';
import 'tool.dart';
import 'vehicle.dart';

class AssignmentsListHolder extends Equatable {
  final List<Assignment> data;

  const AssignmentsListHolder({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

class SingleAssignmentHolder extends Equatable {
  final Assignment data;

  const SingleAssignmentHolder({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

class Assignment extends Equatable {
  final int id;
  final int projectId; //project_id
  final int customerAddressId; //customer_address_id
  final int duration;
  final int timeSpent; //time_spent
  final int breakTime; //break_time
  final int drivingTime; //driving_time
  final bool? isAllDay;
  final String title;
  final String description;
  final String internalNote;
  final OriginalAssignmentState state;
  final DateTime? start;
  final DateTime? end;
  final DateTime createdAt; //created_at
  final DateTime updatedAt; //updated_at
  final List<Tag> tags;
  final CustomerAddress? customerAddress;
  final List<Employee>? employees;
  final List<Tool>? tools;
  final List<Vehicle>? vehicles;
  final List<Document>? documents;
  final List<Documentation> documentations;
  final Project? project;
  final Creation? creation;
  final List<Article>? articles;

  const Assignment({
    required this.id,
    required this.projectId,
    required this.customerAddressId,
    required this.duration,
    required this.timeSpent,
    required this.breakTime,
    required this.drivingTime,
    required this.isAllDay,
    required this.title,
    required this.description,
    required this.internalNote,
    required this.state,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.updatedAt,
    required this.customerAddress,
    required this.tags,
    required this.employees,
    required this.tools,
    required this.vehicles,
    required this.documents,
    required this.documentations,
    required this.project,
    required this.creation,
    required this.articles,
  });

  @override
  List<Object?> get props =>
      [
        id,
        projectId,
        customerAddressId,
        duration,
        timeSpent,
        breakTime,
        drivingTime,
        isAllDay,
        title,
        description,
        internalNote,
        state,
        start,
        end,
        createdAt,
        updatedAt,
        tags,
        customerAddress,
        employees,
        tools,
        vehicles,
        documents,
        documentations,
        project,
        creation,
        articles,
      ];
}

enum OriginalAssignmentState {
  unplanned(),
  scheduled(),
  inProgress(),
  paused(),
  done(),
  delayed(),
  archived();

  InAppAssignmentState get inAppState {
    switch (this) {
      case OriginalAssignmentState.unplanned:
        return InAppAssignmentState.notScheduled;
      case OriginalAssignmentState.scheduled:
        return InAppAssignmentState.scheduled;
      case OriginalAssignmentState.inProgress:
        return InAppAssignmentState.inProgress;
      case OriginalAssignmentState.paused:
        return InAppAssignmentState.paused;
      case OriginalAssignmentState.done:
        return InAppAssignmentState.done;
      case OriginalAssignmentState.delayed:
        return InAppAssignmentState.actionRequired;
      case OriginalAssignmentState.archived:
        return InAppAssignmentState.unsupported;
    }
  }

  String get originalValue {
    switch (this) {
      case OriginalAssignmentState.unplanned:
        return 'UNPLANNED';
      case OriginalAssignmentState.scheduled:
        return 'SCHEDULED';
      case OriginalAssignmentState.inProgress:
        return 'IN_PROGRESS';
      case OriginalAssignmentState.paused:
        return 'PAUSED';
      case OriginalAssignmentState.done:
        return 'DONE';
      case OriginalAssignmentState.delayed:
        return 'DELAYED';
      case OriginalAssignmentState.archived:
        return 'ARCHIVED';
    }
  }
}
