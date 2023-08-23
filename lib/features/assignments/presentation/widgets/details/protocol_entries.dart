import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/theme/colors.dart';
import '../../../../../core/constants/theme/fonts.dart';
import '../../../../../core/constants/theme/images.dart';
import '../../../../../generated/l10n.dart';

class ProtocolEntries extends StatelessWidget {
  const ProtocolEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildProtocolItem(
                backgroundColor: AppColor.darkBlue50,
                icon: SvgPicture.asset(protocolCamera),
                text: S.current.photo,
              ),
              const SizedBox(width: 16),
              _buildProtocolItem(
                backgroundColor: AppColor.blue50,
                icon: SvgPicture.asset(protocolLayers),
                text: S.current.material,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              _buildProtocolItem(
                backgroundColor: AppColor.yellow50,
                icon: SvgPicture.asset(protocolNote),
                text: S.current.note,
              ),
              const SizedBox(width: 16),
              _buildProtocolItem(
                backgroundColor: AppColor.purple50,
                icon: SvgPicture.asset(protocolClock),
                text: S.current.time,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProtocolItem({
    required Color backgroundColor,
    required Widget icon,
    required String text,
  }) {
    return Expanded(
      child: Container(
        height: 68.h,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 17.sp,
                fontFamily: AppFonts.latoFont,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
