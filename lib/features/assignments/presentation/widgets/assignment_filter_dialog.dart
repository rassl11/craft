import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/widgets/craftbox_big_button.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/utils/assignments_utils.dart';
import '../../../../generated/l10n.dart';
import '../blocs/assignments/assignments_bloc.dart';
import 'craftbox_list_divider.dart';

class AssignmentFilterDialog {
  Future<Object?> show(BuildContext context) {
    return showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (
          BuildContext buildContext,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return Scaffold(
            body: BlocProvider.value(
              value: BlocProvider.of<AssignmentsBloc>(context),
              child: BlocBuilder<AssignmentsBloc, AssignmentsState>(
                builder: (builderContext, state) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.only(top: 60).h,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildTitleBarPart(context),
                        _buildFilterList(builderContext, state),
                        const Spacer(),
                        _buildButton(context, state),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  Container _buildTitleBarPart(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: AppColor.darkWhite,
          ),
        ),
      ),
      child: Stack(children: [
        _buildTitle(),
        _buildLeadingBackButton(context),
      ]),
    );
  }

  Align _buildTitle() {
    return Align(
      child: Text(
        S.current.filter,
        style: TextStyle(
          fontFamily: AppFonts.latoFont,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
          color: AppColor.black,
        ),
      ),
    );
  }

  Align _buildLeadingBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 100,
        height: 60,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            arrowLeft,
            fit: BoxFit.fill,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _buildFilterList(BuildContext context, AssignmentsState state) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        left: 16,
        right: 16,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [..._buildFilterTiles(context, state.filterStateMap)],
        ),
      ),
    );
  }

  List<Widget> _buildFilterTiles(
    BuildContext context,
    Map<InAppAssignmentState, bool> filterStateMap,
  ) {
    final List<Widget> filterTiles = [];
    for (final inAppState in availableStates) {
      final isCurrentFilterChecked = filterStateMap[inAppState];
      if (isCurrentFilterChecked == null) {
        continue;
      }

      final filterTile = _buildFilterTile(
        isChecked: isCurrentFilterChecked,
        inAppState: inAppState,
        onTap: () {
          context.read<AssignmentsBloc>().add(
                AssignmentsFilterTapped(state: inAppState),
              );
        },
      );

      filterTiles
        ..add(filterTile)
        ..add(const CraftboxListDivider());
    }

    if (filterTiles.isNotEmpty) {
      filterTiles.removeLast();
    }

    return filterTiles;
  }

  Widget _buildFilterTile({
    required bool isChecked,
    required InAppAssignmentState inAppState,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        inAppState.name,
        style: TextStyle(
          color: AppColor.black,
          fontFamily: AppFonts.latoFont,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      horizontalTitleGap: 2,
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: inAppState.bgColor,
        ),
      ),
      trailing: isChecked
          ? const Icon(
              Icons.check,
              color: AppColor.orange,
            )
          : null,
      onTap: onTap,
    );
  }

  Padding _buildButton(BuildContext context, AssignmentsState state) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 34,
      ),
      child: CraftboxBigButton(
        onPressed: () {
          Navigator.of(context).pop();
          context.read<AssignmentsBloc>().add(
                AssignmentsFetched(
                  isDataUpdateRequired: false,
                  activeSegment: state.activeSegment,
                ),
              );
        },
        title: S.current.filterSeeResults(
          state.assignments.length,
        ),
      ),
    );
  }
}
