import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/widgets/craftbox_container.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/recorded_time.dart';

class RecordedTimeSoFar extends StatelessWidget {
  final RecordedTime totalTimeRecorded;

  const RecordedTimeSoFar({
    super.key,
    required this.totalTimeRecorded,
  });

  @override
  Widget build(BuildContext context) {
    return CraftboxContainer(
      margin: null,
      padding: const EdgeInsets.all(16),
      color: AppColor.purple50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRecordedTimeTitle(),
          const Divider(
            color: AppColor.purple400,
            thickness: 1,
          ),
          _buildRecordedTimeDataRow(totalTimeRecorded),
        ],
      ),
    );
  }

  SizedBox _buildRecordedTimeTitle() {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(protocolClock),
          ),
          Center(
            child: Text(
              S.current.projectTimeRecorded,
              style: TextStyle(
                color: AppColor.black,
                fontFamily: AppFonts.latoFont,
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildRecordedTimeDataRow(RecordedTime totalTimeRecorded) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeValue(
            title: S.current.workingTime,
            time: CraftboxDateTimeUtils.formatTime(
              totalTimeRecorded.workingTime,
            ),
          ),
          _buildPurpleVerticalDivider(),
          _buildTimeValue(
            title: S.current.breakTime,
            time: CraftboxDateTimeUtils.formatTime(
              totalTimeRecorded.breakTime,
            ),
          ),
          _buildPurpleVerticalDivider(),
          _buildTimeValue(
            title: S.current.drivingTime,
            time: CraftboxDateTimeUtils.formatTime(
              totalTimeRecorded.drivingTime,
            ),
          ),
        ],
      ),
    );
  }

  VerticalDivider _buildPurpleVerticalDivider() {
    return const VerticalDivider(
      color: AppColor.purple400,
      thickness: 1,
      indent: 9,
      endIndent: 9,
    );
  }

  Column _buildTimeValue({required String title, required String time}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.black,
            fontFamily: AppFonts.latoFont,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          time,
          style: TextStyle(
            color: AppColor.black,
            fontFamily: AppFonts.latoFont,
            fontSize: 19.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
