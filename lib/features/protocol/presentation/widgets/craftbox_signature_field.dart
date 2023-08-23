import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';

class CraftboxSignatureField extends StatelessWidget {
  final bool _isErrorIndicationRequired;
  final String _title;
  final VoidCallback _onTap;
  final Uint8List? _signature;
  final double _height;

  const CraftboxSignatureField({
    super.key,
    required bool isErrorIndicationRequired,
    required String title,
    required void Function() onTap,
    double height = 180,
    Uint8List? signature,
  })  : _signature = signature,
        _onTap = onTap,
        _title = title,
        _isErrorIndicationRequired = isErrorIndicationRequired,
        _height = height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _signature == null ? _onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildText(),
          8.verticalSpace,
          Container(
            width: double.infinity,
            height: _height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.grayControls,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                width: 2,
                color: _isErrorIndicationRequired
                    ? AppColor.red500
                    : AppColor.grayBorder,
              ),
            ),
            child: _signature == null
                ? SizedBox(
                    height: 36,
                    width: 36,
                    child: getFaIcon(CraftboxIcon.penLine),
                  )
                : Image.memory(_signature ?? Uint8List(0)),
          ),
        ],
      ),
    );
  }

  Widget _buildText() {
    if (_title != '') {
      return Text(
        _title,
        style: TextStyle(
          fontFamily: AppFonts.latoFont,
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.black,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
