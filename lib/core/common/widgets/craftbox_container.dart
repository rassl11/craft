import 'package:flutter/material.dart';

import '../../constants/theme/colors.dart';

class CraftboxContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color color;

  const CraftboxContainer({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.padding,
    this.color = AppColor.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
      ),
      child: child,
    );
  }
}
