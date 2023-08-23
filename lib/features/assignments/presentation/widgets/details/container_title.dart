import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/theme/fonts.dart';

class ContainerTitle extends StatelessWidget {
  final String _title;
  final double? _width;
  final EdgeInsetsGeometry? _padding;
  final Color _textColor;

  const ContainerTitle({
    Key? key,
    required String title,
    double? width = double.infinity,
    EdgeInsetsGeometry? padding = const EdgeInsets.only(
      left: 16,
      top: 16,
      bottom: 8,
    ),
    Color textColor = const Color(0xFF000000),
  })  : _textColor = textColor,
        _padding = padding,
        _width = width,
        _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      padding: _padding,
      alignment: Alignment.topLeft,
      child: Text(
        _title,
        style: TextStyle(
          fontSize: 20.sp,
          fontFamily: AppFonts.latoFont,
          fontWeight: FontWeight.w800,
          color: _textColor,
        ),
      ),
    );
  }
}
