import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/theme/colors.dart';

class CraftboxListDivider extends StatelessWidget {
  const CraftboxListDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.w),
      child: const Divider(
        height: 1,
        color: AppColor.gray,
      ),
    );
  }
}
