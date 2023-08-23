import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../generated/l10n.dart';

enum ActiveSegment { past, sinceToday, notScheduled }

class CraftboxSlider extends StatelessWidget {
  static const edgeInsets = EdgeInsets.symmetric(horizontal: 5, vertical: 10);

  final ActiveSegment selectedSegment;
  final Function(ActiveSegment activeSegment) onValueChanged;

  const CraftboxSlider({
    super.key,
    required this.selectedSegment,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<ActiveSegment>(
      backgroundColor: AppColor.sliderBgGray,
      thumbColor: AppColor.black,
      groupValue: selectedSegment,
      onValueChanged: (ActiveSegment? value) {
        if (value != null) {
          onValueChanged(value);
        }
      },
      children: <ActiveSegment, Widget>{
        ActiveSegment.past: _buildItem(S.current.past, ActiveSegment.past),
        ActiveSegment.sinceToday: _buildItem(
          S.current.sinceToday,
          ActiveSegment.sinceToday,
        ),
        ActiveSegment.notScheduled: _buildItem(
          S.current.not_scheduled,
          ActiveSegment.notScheduled,
        ),
      },
    );
  }

  Padding _buildItem(String text, ActiveSegment tabName) {
    return Padding(
      padding: edgeInsets,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.latoFont,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: selectedSegment == tabName ? AppColor.white : AppColor.black,
        ),
      ),
    );
  }
}
