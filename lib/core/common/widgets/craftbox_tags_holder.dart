import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../features/assignments/domain/entities/assignments_data_holder.dart';
import '../../../features/assignments/domain/entities/tag.dart';
import '../../constants/theme/colors.dart';
import '../../constants/theme/fonts.dart';
import '../../constants/theme/images.dart';

class CraftboxTagsHolder extends StatelessWidget {
  final Assignment assignment;

  const CraftboxTagsHolder({
    Key? key,
    required this.assignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tags = assignment.tags;
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          ...tags.map(_buildTag).toList(),
        ],
      ),
    );
  }

  Widget _buildTag(Tag tag) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(HexColor.fromHex(tag.color)),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(
          const Size(0, 31),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 9),
            child: SvgPicture.asset(
              getFAIconPath(tag.icon),
              height: 15,
              width: 15,
              colorFilter: const ColorFilter.mode(
                AppColor.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          Text(
            tag.name,
            style: TextStyle(
              color: AppColor.white,
              fontFamily: AppFonts.latoFont,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
