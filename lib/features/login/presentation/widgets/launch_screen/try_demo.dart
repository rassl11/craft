import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/theme/colors.dart';
import '../../../../../core/constants/theme/fonts.dart';
import '../../../../../generated/l10n.dart';
import 'text_with_yellow_arrow.dart';

class TryDemo extends StatelessWidget {
  const TryDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.sh,
      width: double.infinity,
      color: AppColor.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 70).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextWithYellowArrow(),
            20.verticalSpace,
            _buildBottomText()
          ],
        ),
      ),
    );
  }

  SizedBox _buildBottomText() {
    return SizedBox(
      child: Text(
        S.current.launchTryDemoDescription,
        style: TextStyle(
          height: 1.5,
          fontFamily: AppFonts.latoFont,
          fontSize: 19.sp,
          color: AppColor.white.withOpacity(0.8),
        ),
      ),
    );
  }

  TextWithYellowArrow _buildTextWithYellowArrow() {
    return TextWithYellowArrow(
      color: AppColor.white,
      text: S.current.launchTryDemo,
    );
  }
}
