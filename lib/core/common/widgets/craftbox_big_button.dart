import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/theme/colors.dart';
import '../../constants/theme/fonts.dart';
import '../../constants/theme/images.dart';

class CraftboxBigButton extends StatelessWidget {
  final bool isOutlined;
  final double height;
  final double borderRadius;
  final String title;
  final Color backgroundColor;
  final Function() onPressed;
  final FontStyle? fontStyle;
  final String outlinedButtonIcon;

  const CraftboxBigButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.backgroundColor = AppColor.black,
    this.isOutlined = false,
    this.borderRadius = 20,
    this.height = 60,
    this.fontStyle = FontStyle.normal,
    this.outlinedButtonIcon = '',
  });

  @override
  Widget build(BuildContext context) {
    return isOutlined ? _buildOutlinedButton() : _buildFilledButton();
  }

  OutlinedButton _buildOutlinedButton() {
    return OutlinedButton(
      style: _getButtonStyle().copyWith(
        side: MaterialStateProperty.all(
          const BorderSide(
            width: 2,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOutlinedButtonIcon(),
          Text(
            title,
            style: _getTextStyle().copyWith(
              color: AppColor.black,
              fontStyle: fontStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedButtonIcon() {
    return outlinedButtonIcon != ''
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                plus,
                colorFilter: const ColorFilter.mode(
                  AppColor.black,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
            ],
          )
        : const SizedBox.shrink();
  }

  FilledButton _buildFilledButton() {
    return FilledButton(
      style: _getButtonStyle().copyWith(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
      ),
      onPressed: onPressed,
      child: Text(
        style: _getTextStyle().copyWith(
          color: AppColor.white,
          fontStyle: fontStyle,
        ),
        title,
      ),
    );
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontFamily: AppFonts.latoFont,
      fontSize: 17.sp,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    );
  }

  ButtonStyle _getButtonStyle() {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(
        Size(
          1.sw,
          height,
        ),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
