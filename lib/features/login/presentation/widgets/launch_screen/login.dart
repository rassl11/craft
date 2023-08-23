import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/theme/colors.dart';
import '../../../../../core/constants/theme/fonts.dart';
import '../../../../../generated/l10n.dart';
import '../../pages/login_screen.dart';
import 'text_with_yellow_arrow.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, LoginScreen.routeName);
      },
      excludeFromSemantics: true,
      child: Container(
        height: 0.5.sh,
        width: double.infinity,
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 70).r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextWithYellowArrow(),
              20.verticalSpace,
              _buildBottomText()
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildBottomText() {
    return SizedBox(
      width: 220.r,
      child: Text(
        S.current.launchLoginDescription,
        style: TextStyle(
          height: 1.5,
          fontFamily: AppFonts.latoFont,
          color: AppColor.gray,
          fontWeight: FontWeight.w400,
          fontSize: 19.sp,
        ),
      ),
    );
  }

  TextWithYellowArrow _buildTextWithYellowArrow() {
    return TextWithYellowArrow(
      color: AppColor.black,
      text: S.current.launchLogin,
    );
  }
}
