import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';
import '../../constants/theme/colors.dart';
import '../../constants/theme/fonts.dart';
import '../../utils/date_utils.dart';

class ProjectTimePicker extends StatefulWidget {
  final TimeRecordType type;
  final Function(TimeRecordType, Duration, String) onDoneTap;

  const ProjectTimePicker({
    super.key,
    required this.type,
    required this.onDoneTap,
  });

  @override
  State<ProjectTimePicker> createState() => _ProjectTimePickerState();
}

class _ProjectTimePickerState extends State<ProjectTimePicker> {
  Duration _duration = const Duration();
  String _humanReadableTime = S.current.timePlaceholder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButtons(context),
          _buildPicker(),
        ],
      ),
    );
  }

  SizedBox _buildPicker() {
    return SizedBox(
      height: 200,
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        minuteInterval: 5,
        onTimerDurationChanged: (Duration newDuration) {
          _duration = newDuration;
          _humanReadableTime =
              CraftboxDateTimeUtils.formatDurationTime(newDuration);
        },
      ),
    );
  }

  Container _buildButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 5,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCancelButton(context),
          _buildDoneButton(),
        ],
      ),
    );
  }

  TextButton _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        S.current.cancel,
        style: TextStyle(
          color: AppColor.black,
          fontFamily: AppFonts.latoFont,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  TextButton _buildDoneButton() {
    return TextButton(
      onPressed: () {
        widget.onDoneTap(widget.type, _duration, _humanReadableTime);
        Navigator.pop(context);
      },
      child: Text(
        S.current.filterDone,
        style: TextStyle(
          color: AppColor.accent400,
          fontFamily: AppFonts.latoFont,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
