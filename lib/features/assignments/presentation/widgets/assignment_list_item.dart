import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/common/widgets/craftbox_circle_avatars.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../domain/entities/employee.dart';

class AssignmentListItem extends StatelessWidget {
  final bool isTrailingArrowEnabled;
  final String text;
  final String? leadingImageUrl;
  final IconData? iconData;
  final SvgPicture? svgPicture;
  final List<Employee>? assigners;
  final VoidCallback? onTap;

  const AssignmentListItem({
    super.key,
    this.isTrailingArrowEnabled = false,
    this.leadingImageUrl,
    required this.text,
    this.iconData,
    this.svgPicture,
    this.assigners,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: (assigners == null || assigners!.isEmpty)
          ? _buildTextOnlyTitle()
          : _buildTitleWithAvatars(),
      horizontalTitleGap: 2,
      visualDensity: const VisualDensity(vertical: -3),
      leading: _buildLeadingImage(),
      trailing: isTrailingArrowEnabled
          ? const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColor.orange,
              ),
            )
          : null,
      onTap: onTap,
    );
  }

  Container _buildLeadingImage() {
    if (leadingImageUrl != null && leadingImageUrl!.isNotEmpty) {
      return Container(
        width: 25,
        height: 25,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            image: NetworkImage(leadingImageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 5),
      height: double.infinity,
      child:
          iconData != null ? Icon(iconData, color: AppColor.black) : svgPicture,
    );
  }

  Padding _buildTextOnlyTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: _buildTitleText(),
    );
  }

  Container _buildTitleWithAvatars() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitleText(),
          if (assigners == null || assigners!.isEmpty)
            const SizedBox.shrink()
          else
            CraftboxCircleAvatars(assigners: assigners!),
        ],
      ),
    );
  }

  Text _buildTitleText() {
    return Text(
      text,
      style: TextStyle(
        color: AppColor.black,
        fontFamily: AppFonts.latoFont,
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
