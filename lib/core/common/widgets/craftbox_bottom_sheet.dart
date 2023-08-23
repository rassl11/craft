import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/theme/colors.dart';
import 'craftbox_big_button.dart';

class CraftboxBottomSheet extends StatelessWidget {
  final String buttonTitle;
  final String secondButtonTitle;
  final VoidCallback onButtonPressed;
  final VoidCallback? onSecondButtonPressed;
  final FontStyle? fontStyle;
  final String outlinedButtonIcon;

  const CraftboxBottomSheet({
    super.key,
    required this.buttonTitle,
    this.secondButtonTitle = '',
    required this.onButtonPressed,
    this.onSecondButtonPressed,
    this.fontStyle,
    this.outlinedButtonIcon = '',
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDragHandle: false,
      enableDrag: false,
      elevation: 10,
      onClosing: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 110.h,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ..._buildSecondButton(),
              Expanded(
                child: CraftboxBigButton(
                  title: buttonTitle,
                  onPressed: onButtonPressed,
                  fontStyle: fontStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSecondButton() {
    return secondButtonTitle != ''
        ? [
            Expanded(
              child: CraftboxBigButton(
                isOutlined: true,
                title: secondButtonTitle,
                onPressed: onSecondButtonPressed ?? () => {},
                fontStyle: fontStyle,
                outlinedButtonIcon: outlinedButtonIcon,
              ),
            ),
            10.horizontalSpace,
          ]
        : [const SizedBox.shrink()];
  }
}
