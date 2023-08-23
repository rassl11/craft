import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/theme/fonts.dart';
import '../../../../../core/constants/theme/images.dart';

class TextWithYellowArrow extends StatelessWidget {
  final String text;
  final Color color;

  const TextWithYellowArrow({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: AppFonts.latoFont,
            fontWeight: FontWeight.w700,
            fontSize: 37.sp,
            color: color,
          ),
        ),
        20.horizontalSpace,
        SvgPicture.asset(arrowRightYellow, width: 36.r)
      ],
    );
  }
}
