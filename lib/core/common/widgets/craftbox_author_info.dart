import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/assignments/domain/entities/creation.dart';
import '../../../generated/l10n.dart';
import '../../constants/theme/colors.dart';
import '../../constants/theme/fonts.dart';

class CraftboxAuthorInfo extends StatelessWidget {
  final Causer? causer;
  final String text;
  final String updatedAtDate;

  const CraftboxAuthorInfo({
    super.key,
    required this.causer,
    required this.text,
    required this.updatedAtDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 60).h,
      child: Column(
        children: [
          Text(
            '$text: $updatedAtDate',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: AppFonts.latoFont,
              fontWeight: FontWeight.w400,
              color: AppColor.transparentBlack50,
            ),
          ),
          2.verticalSpace,
          Text(
            '${causer?.firstName} ${causer?.lastName} ${S.current.contact}',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: AppFonts.latoFont,
              fontWeight: FontWeight.w400,
              shadows: const [
                Shadow(
                  offset: Offset(0, -3),
                )
              ],
              color: Colors.transparent,
              decoration: TextDecoration.underline,
              decorationColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
