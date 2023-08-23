import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/assignments/domain/entities/assignments_data_holder.dart';
import '../../generated/l10n.dart';

class CraftboxDateTimeUtils {
  static String getFormattedDate(
    BuildContext context,
    DateTime? date, {
    bool dateOnly = false,
    bool isDateWithTimeRequired = false,
  }) {
    if (date == null) {
      return '';
    }

    final String locale = Localizations.localeOf(context).languageCode;
    if (isDateWithTimeRequired) {
      return DateFormat.yMEd(locale)
          .add_Hm()
          .format(date.add(DateTime.now().timeZoneOffset));
    }

    final dateFormat =
        dateOnly ? DateFormat.yMd(locale) : DateFormat.yMEd(locale);

    return dateFormat.format(date.add(DateTime.now().timeZoneOffset));
  }

  static String getTime(
    BuildContext context,
    DateTime? date,
  ) {
    if (date == null) {
      return '';
    }

    final String locale = Localizations.localeOf(context).languageCode;
    return DateFormat.Hm(locale)
        .format(date.add(DateTime.now().timeZoneOffset));
  }

  static String getScheduledPeriodOfTime(
    BuildContext context,
    Assignment assignment,
  ) {
    final startTime = getFormattedDate(context, assignment.start);
    final endTime = getFormattedDate(context, assignment.end);
    final String scheduledPeriodOfTime;
    if (startTime == endTime && (assignment.isAllDay ?? false)) {
      scheduledPeriodOfTime = startTime;
    } else {
      scheduledPeriodOfTime = '$startTime - $endTime';
    }

    return scheduledPeriodOfTime;
  }

  static String formatTime(int minutes) {
    final duration = Duration(minutes: minutes);
    return formatDurationTime(duration);
  }

  static String formatDurationTime(Duration duration) {
    final minutes = duration.inMinutes;
    final remainder = minutes.remainder(60);

    if (minutes == 0) {
      return S.current.timePlaceholder;
    }

    if (remainder == 0) {
      return '${duration.inHours}h 0m';
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(remainder);

    return '${duration.inHours}h ${twoDigitMinutes}m';
  }
}

enum TimeRecordType {
  timeSpent,
  breakTime,
  drivingTime,
}
