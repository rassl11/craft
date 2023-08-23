import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/theme/colors.dart';
import '../../constants/theme/fonts.dart';
import '../../constants/theme/images.dart';

class CraftboxAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color titleColor;
  final String leadingIconPath;
  final Color? leadingIconColor;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final PreferredSize? bottomWidget;
  final Function? onLeadingIconPressed;
  final int? activeFilters;

  const CraftboxAppBar({
    super.key,
    required this.title,
    this.titleColor = AppColor.black,
    required this.leadingIconPath,
    this.leadingIconColor,
    this.backgroundColor,
    this.actions,
    this.bottomWidget,
    this.onLeadingIconPressed,
    this.activeFilters,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottomWidget,
      backgroundColor: backgroundColor ?? AppColor.background,
      elevation: 1,
      centerTitle: true,
      title: _buildTitle(),
      leadingWidth: leadingIconPath == arrowLeft ? 100 : null,
      leading: leadingIconPath.isNotEmpty
          ? Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                IconButton(
                  icon: _buildIcon(),
                  onPressed: () {
                    if (onLeadingIconPressed != null) {
                      onLeadingIconPressed?.call();
                      return;
                    }
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18, left: 18),
                  child: Visibility(
                    visible: activeFilters != null && activeFilters! > 0,
                    child: _buildActiveFiltersIcon()
                  ),
                ),
              ],
            )
          : null,
      actions: actions,
    );
  }

  IgnorePointer _buildActiveFiltersIcon() {
    return IgnorePointer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(activeFiltersIcon),
          _buildActiveFiltersText(),
        ],
      ),
    );
  }

  Text _buildActiveFiltersText() {
    return Text(
      '$activeFilters',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        fontFamily: AppFonts.latoFont,
      ),
    );
  }

  Widget _buildTitle() {
    Widget titleWidget = Text(
      title,
      style: TextStyle(
        fontFamily: AppFonts.latoFont,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: titleColor,
      ),
    );

    const maxLength = 18;
    if (title.length > maxLength) {
      titleWidget = SizedBox(
        width: 0.5.sw,
        child: titleWidget,
      );
    }

    return titleWidget;
  }

  SvgPicture _buildIcon() {
    return SvgPicture.asset(
      leadingIconPath,
      colorFilter: ColorFilter.mode(
        leadingIconColor ?? AppColor.orange,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_calculatePreferredSize());

  double _calculatePreferredSize() {
    if (bottomWidget == null) {
      return kToolbarHeight;
    } else {
      return kToolbarHeight + bottomWidget!.preferredSize.height;
    }
  }
}
