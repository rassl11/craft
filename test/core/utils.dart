import 'package:share/features/assignments/domain/entities/assignments_data_holder.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';

Assignment getDummyAssignment(
  DateTime? start, {
  OriginalAssignmentState state = OriginalAssignmentState.scheduled,
  bool isAllDay = false,
  List<Documentation>? documentations,
}) {
  return Assignment(
    id: 123,
    projectId: 123,
    customerAddressId: 123,
    isAllDay: isAllDay,
    title: 'title',
    state: state,
    start: start,
    end: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    customerAddress: null,
    tags: const [],
    description: 'instruct: Fix the door',
    internalNote: 'Important hint',
    employees: null,
    tools: null,
    vehicles: null,
    documents: null,
    project: null,
    creation: null,
    documentations: documentations ?? List.empty(),
    duration: 1,
    timeSpent: 0,
    breakTime: 0,
    drivingTime: 0,
    articles: null,
  );
}

Documentation getDummyDocumentation() {
  return Documentation(
    id: 123,
    assignmentId: 123,
    workingTime: 0,
    breakTime: 0,
    type: DocumentationType.note,
    title: 'd',
    description: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
