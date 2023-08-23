import 'dart:ui';

import 'package:flutter/material.dart';

import '../../features/assignments/domain/entities/assignments_data_holder.dart';
import '../../generated/l10n.dart';
import '../constants/theme/colors.dart';

const List<InAppAssignmentState> availableStates = [
  InAppAssignmentState.scheduled,
  InAppAssignmentState.inProgress,
  InAppAssignmentState.paused,
  InAppAssignmentState.actionRequired,
  InAppAssignmentState.done,
];

enum InAppAssignmentState {
  scheduled(),
  inProgress(),
  actionRequired(),
  paused(),
  notScheduled(),
  done(),
  unsupported();

  String get name {
    switch (this) {
      case InAppAssignmentState.scheduled:
        return S.current.filterScheduled;
      case InAppAssignmentState.inProgress:
        return S.current.filterInProgress;
      case InAppAssignmentState.actionRequired:
        return S.current.actionRequired;
      case InAppAssignmentState.paused:
        return S.current.paused;
      case InAppAssignmentState.notScheduled:
        return S.current.not_scheduled;
      case InAppAssignmentState.done:
        return S.current.filterDone;
      case InAppAssignmentState.unsupported:
        return 'unsupported';
    }
  }

  OriginalAssignmentState get originalAssignmentState {
    switch (this) {
      case InAppAssignmentState.scheduled:
        return OriginalAssignmentState.scheduled;
      case InAppAssignmentState.inProgress:
        return OriginalAssignmentState.inProgress;
      case InAppAssignmentState.actionRequired:
        return OriginalAssignmentState.delayed;
      case InAppAssignmentState.paused:
        return OriginalAssignmentState.paused;
      case InAppAssignmentState.notScheduled:
        return OriginalAssignmentState.unplanned;
      case InAppAssignmentState.done:
        return OriginalAssignmentState.done;
      default:
        return OriginalAssignmentState.archived;
    }
  }

  Color get bgColor {
    switch (this) {
      case InAppAssignmentState.scheduled:
        return AppColor.gray400;
      case InAppAssignmentState.inProgress:
        return AppColor.blue500;
      case InAppAssignmentState.actionRequired:
        return AppColor.red500;
      case InAppAssignmentState.paused:
        return AppColor.accent400;
      case InAppAssignmentState.notScheduled:
        return AppColor.gray400;
      case InAppAssignmentState.done:
        return AppColor.green500;
      default:
        return AppColor.gray400;
    }
  }

  Color get buttonColor {
    switch (this) {
      case InAppAssignmentState.scheduled:
        return AppColor.statusButtonGray;
      case InAppAssignmentState.inProgress:
        return AppColor.statusButtonBlue;
      case InAppAssignmentState.actionRequired:
        return AppColor.statusButtonRed;
      case InAppAssignmentState.paused:
        return AppColor.statusButtonYellow;
      case InAppAssignmentState.notScheduled:
        return AppColor.statusButtonGray;
      case InAppAssignmentState.done:
        return AppColor.statusButtonGreen;
      default:
        return AppColor.statusButtonGray;
    }
  }
}

String getAddress(Assignment assignment) {
  final String street = assignment.customerAddress?.street ?? '';
  final String streetAddon = assignment.customerAddress?.streetAddon ?? '';
  final String zip = assignment.customerAddress?.zip ?? '';
  final String city = assignment.customerAddress?.city ?? '';
  final String country = assignment.customerAddress?.country ?? '';
  return '$street, ${streetAddon.isNotEmpty ? '$streetAddon,' : ''} '
      '$zip $city, $country';
}
