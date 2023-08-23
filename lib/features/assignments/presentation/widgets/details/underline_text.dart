import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/theme/fonts.dart';

class UnderlineText extends StatelessWidget {
  final String _textToShow;
  final double? _width;
  final EdgeInsetsGeometry? _padding;
  final VoidCallback? _onTap;

  const UnderlineText({
    super.key,
    required String textToShow,
    double? width = double.infinity,
    EdgeInsetsGeometry? padding = const EdgeInsets.only(left: 16, right: 8),
    void Function()? onTap,
  })  : _onTap = onTap,
        _padding = padding,
        _width = width,
        _textToShow = textToShow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      alignment: Alignment.bottomRight,
      padding: _padding,
      child: TextButton(
        onPressed: _onTap,
        child: Text(
          _textToShow,
          style: TextStyle(
            shadows: const [
              Shadow(
                offset: Offset(0, -3),
              )
            ],
            color: Colors.transparent,
            decoration: TextDecoration.underline,
            decorationColor: Colors.black,
            fontSize: 17.sp,
            fontFamily: AppFonts.latoFont,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
