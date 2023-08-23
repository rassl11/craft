import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/theme/colors.dart';
import '../../constants/theme/fonts.dart';

class CraftboxMenuList extends StatelessWidget {
  final String listTitle;
  final List<CraftboxMenuListItem> items;

  const CraftboxMenuList({
    super.key,
    required this.listTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: listTitle != '',
          child: Text(
            listTitle,
            style: TextStyle(
              fontFamily: AppFonts.latoFont,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColor.black,
            ),
          ),
        ),
        20.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return items[index];
            },
            padding: EdgeInsets.zero,
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(left: 50.w),
                child: const Divider(
                  height: 1,
                  color: AppColor.gray,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class CraftboxMenuListItem extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final SvgPicture? svgPicture;
  final VoidCallback onItemTap;
  final Color arrowColor;

  const CraftboxMenuListItem({
    Key? key,
    required this.title,
    this.iconData,
    this.svgPicture,
    this.arrowColor = AppColor.orange,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 46,
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        horizontalTitleGap: 2,
        onTap: onItemTap,
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          height: double.infinity,
          width: 24,
          child: iconData != null
              ? Icon(iconData, color: AppColor.black)
              : svgPicture,
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: arrowColor),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.latoFont,
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.black,
          ),
        ),
      ),
    );
  }
}
