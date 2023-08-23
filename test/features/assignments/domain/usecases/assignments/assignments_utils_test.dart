import 'package:flutter_test/flutter_test.dart';
import 'package:share/features/assignments/domain/entities/assignments_data_holder.dart';
import 'package:share/features/assignments/domain/usecases/assignments/assignments_refiner.dart';
import 'package:share/features/assignments/presentation/widgets/craftbox_slider.dart';

import '../../../../../core/utils.dart';

void main() {
  late AssignmentsRefiner utils;

  setUp(() {
    utils = AssignmentsRefiner();
  });

  group('getFilteredAssignments', () {
    test(
        'should return assignments with start date before today when '
        'ActiveSegment.past', () {
      // arrange
      final today = DateTime.now();
      final dayBefore = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final tResult = [
        getDummyAssignment(dayBefore),
        getDummyAssignment(twoDaysAgo),
      ];
      final assignments = [
        getDummyAssignment(today),
        ...tResult,
      ];
      // act
      final result = utils.getFilteredAssignments(
        unfilteredAssignments: assignments,
        activeSegment: ActiveSegment.past,
        requestedStates: [],
      );
      // assert
      expect(result, tResult);
    });

    test(
        'should return assignments with start date from today when '
        'ActiveSegment.sinceToday', () {
      // arrange
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));
      final dayBefore = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final tResult = [
        getDummyAssignment(today),
        getDummyAssignment(tomorrow),
      ];
      final assignments = [
        getDummyAssignment(dayBefore),
        getDummyAssignment(twoDaysAgo),
        ...tResult,
      ];
      // act
      final result = utils.getFilteredAssignments(
        unfilteredAssignments: assignments,
        activeSegment: ActiveSegment.sinceToday,
        requestedStates: [],
      );
      // assert
      expect(result, tResult);
    });

    test(
        'should return assignments without start date when '
        'ActiveSegment.notScheduled', () {
      // arrange
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final tResult = [
        getDummyAssignment(null),
      ];
      final assignments = [
        getDummyAssignment(today),
        getDummyAssignment(tomorrow),
        getDummyAssignment(twoDaysAgo),
        ...tResult,
      ];
      // act
      final result = utils.getFilteredAssignments(
        unfilteredAssignments: assignments,
        activeSegment: ActiveSegment.notScheduled,
        requestedStates: [],
      );
      // assert
      expect(result, tResult);
    });

    test(
        'should return assignments with AssignmentState.paused and '
        'AssignmentState.delayed if requestedStates list contains them', () {
      // arrange
      final today = DateTime.now();
      final dayBefore = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final tResult = [
        getDummyAssignment(dayBefore, state: OriginalAssignmentState.paused),
        getDummyAssignment(twoDaysAgo, state: OriginalAssignmentState.delayed),
      ];
      final assignments = [
        getDummyAssignment(today),
        ...tResult,
      ];
      // act
      final result = utils.getFilteredAssignments(
        unfilteredAssignments: assignments,
        activeSegment: ActiveSegment.past,
        requestedStates: [
          OriginalAssignmentState.paused,
          OriginalAssignmentState.delayed
        ],
      );
      // assert
      expect(result, tResult);
    });

    test(
        'should return assignments with AssignmentState.scheduled and '
        'AssignmentState.inProgress if requestedStates list contains them', () {
      // arrange
      final today = DateTime.now();
      final dayBefore = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final tResult = [
        getDummyAssignment(dayBefore),
        getDummyAssignment(twoDaysAgo,
            state: OriginalAssignmentState.inProgress),
      ];
      final assignments = [
        getDummyAssignment(today),
        ...tResult,
      ];
      // act
      final result = utils.getFilteredAssignments(
        unfilteredAssignments: assignments,
        activeSegment: ActiveSegment.past,
        requestedStates: [
          OriginalAssignmentState.scheduled,
          OriginalAssignmentState.inProgress,
        ],
      );
      // assert
      expect(result, tResult);
    });

    test(
        'should return assignments with AssignmentState.done if requestedStates'
        ' list contains them', () {
      // arrange
      final today = DateTime.now();
      final dayBefore = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final tResult = [
        getDummyAssignment(twoDaysAgo, state: OriginalAssignmentState.done),
      ];
      final assignments = [
        getDummyAssignment(dayBefore),
        getDummyAssignment(today),
        ...tResult,
      ];
      // act
      final result = utils.getFilteredAssignments(
        unfilteredAssignments: assignments,
        activeSegment: ActiveSegment.past,
        requestedStates: [
          OriginalAssignmentState.done,
        ],
      );
      // assert
      expect(result, tResult);
    });
  });

  group('compareAppointments', () {
    final dateTime = DateTime.now();
    test(
        'should return 0 if both appointments have the same start '
        'date and time', () {
      // arrange
      final tAppointment1 = getDummyAssignment(dateTime);
      final tAppointment2 = getDummyAssignment(dateTime);
      // act
      final result = utils.compareAppointments(tAppointment1, tAppointment2);
      // assert
      expect(result, 0);
    });

    test(
        'should return 0 if both appointments have isAllDay=true and the same '
        'start date and time', () {
      // arrange
      final tAppointment1 = getDummyAssignment(dateTime, isAllDay: true);
      final tAppointment2 = getDummyAssignment(dateTime, isAllDay: true);
      // act
      final result = utils.compareAppointments(tAppointment1, tAppointment2);
      // assert
      expect(result, 0);
    });

    test(
        'should return 0 if one appointments have isAllDay=true, but another '
        'dont even if their start dates are different', () {
      // arrange
      final tAppointment1 = getDummyAssignment(dateTime);
      final tAppointment2 = getDummyAssignment(
        dateTime.subtract(const Duration(days: 1)),
        isAllDay: true,
      );
      // act
      final result = utils.compareAppointments(tAppointment1, tAppointment2);
      // assert
      expect(result, 0);
    });

    test(
        'should return 1 if appointment1 has a start date and time after '
        'appointment2', () {
      // arrange
      final tAppointment1 = getDummyAssignment(dateTime);
      final tAppointment2 =
          getDummyAssignment(dateTime.subtract(const Duration(days: 1)));
      // act
      final result = utils.compareAppointments(tAppointment1, tAppointment2);
      // assert
      expect(result, 1);
    });

    test(
        'should return 1 if appointment1 has a start date and time after '
        'appointment2 and both have isAllDay=true', () {
      // arrange
      final tAppointment1 = getDummyAssignment(dateTime, isAllDay: true);
      final tAppointment2 = getDummyAssignment(
        dateTime.subtract(const Duration(days: 1)),
        isAllDay: true,
      );
      // act
      final result = utils.compareAppointments(tAppointment1, tAppointment2);
      // assert
      expect(result, 1);
    });

    test(
        'should return -1 if appointment1 has a start date and time before '
        'appointment2', () {
      // arrange
      final tAppointment1 =
          getDummyAssignment(dateTime.subtract(const Duration(days: 1)));
      final tAppointment2 = getDummyAssignment(dateTime);
      // act
      final result = utils.compareAppointments(tAppointment1, tAppointment2);
      // assert
      expect(result, -1);
    });

    test(
        'should return -1 if appointment1 has a start date and time before '
        'appointment2  and both have isAllDay=true', () {
      // arrange
      final tAppointment1 = getDummyAssignment(
        dateTime.subtract(const Duration(days: 1)),
        isAllDay: true,
      );
      final tAppointment2 = getDummyAssignment(dateTime, isAllDay: true);
      // act
      final result = utils.compareAppointments(tAppointment1, tAppointment2);
      // assert
      expect(result, -1);
    });
  });
}