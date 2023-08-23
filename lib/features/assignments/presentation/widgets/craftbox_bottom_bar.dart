import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../generated/l10n.dart';

enum ActiveTab { assignments, timesheet, more }

class CraftboxBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(ActiveTab activeTab) onItemTap;

  const CraftboxBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _buildItems(),
      currentIndex: selectedIndex,
      unselectedItemColor: AppColor.darkGray,
      selectedItemColor: AppColor.black,
      backgroundColor: AppColor.white,
      onTap: (index) {
        onItemTap(ActiveTab.values[index]);
      },
    );
  }

  List<BottomNavigationBarItem> _buildItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(fileBlack),
        icon: SvgPicture.asset(fileGray),
        label: S.current.appointments,
      ),
      BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(timerBlack),
        icon: SvgPicture.asset(timerGray),
        label: S.current.timesheet,
      ),
      BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(etcBlack),
        icon: SvgPicture.asset(etcGray),
        label: S.current.more,
      ),
    ];
  }
}
