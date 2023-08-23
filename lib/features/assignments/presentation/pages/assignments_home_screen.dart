import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_big_button.dart';
import '../../../../core/common/widgets/craftbox_menu_list.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/dialog_provider.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../login/presentation/pages/launch_screen.dart';
import '../blocs/assignments/assignments_bloc.dart';
import '../blocs/bottom_bar/bottom_bar_bloc.dart';
import '../blocs/logout/logout_bloc.dart';
import '../blocs/slider/slider_bloc.dart';
import '../widgets/assignment_filter_dialog.dart';
import '../widgets/assignments_list.dart';
import '../widgets/craftbox_bottom_bar.dart';
import '../widgets/craftbox_slider.dart';

class AssignmentsHomeScreen extends StatelessWidget {
  static const routeName = '/assignmentsHome';

  const AssignmentsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomBarBloc>(
          create: (_) => sl<BottomBarBloc>(),
        ),
        BlocProvider<LogoutBloc>(
          create: (_) => sl<LogoutBloc>(),
        ),
        BlocProvider<SliderBloc>(
          create: (_) => sl<SliderBloc>(),
        ),
        BlocProvider<AssignmentsBloc>(
          create: (_) => sl<AssignmentsBloc>(),
        ),
      ],
      child: BlocListener<LogoutBloc, LogoutState>(
        listener: (context, state) {
          switch (state.logoutStatus) {
            case Status.error:
            case Status.loaded:
              hideSnackBar(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                LaunchScreen.routeName,
                (route) => false,
              );
              break;
            case Status.loading:
              showSnackBarWithText(context, S.current.indicatorLoggingOut);
              break;
            default:
              break;
          }
        },
        child: BlocBuilder<BottomBarBloc, BottomBarState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColor.background,
              appBar: _buildCraftboxAppBar(context, state),
              body: _buildBody(context, state),
              bottomNavigationBar: _buildBottomTabBar(context, state),
            );
          },
        ),
      ),
    );
  }

  CraftboxAppBar _buildCraftboxAppBar(
    BuildContext context,
    BottomBarState state,
  ) {
    switch (state.activeTab) {
      case ActiveTab.assignments:
        return _getAppBarWithSlider(context);
      case ActiveTab.timesheet:
        return _getAppBarWithSlider(context);
      case ActiveTab.more:
        return CraftboxAppBar(
          title: S.current.more,
          backgroundColor: AppColor.white,
          leadingIconPath: '',
        );
    }
  }

  CraftboxAppBar _getAppBarWithSlider(BuildContext context) {
    final assignmentState = context.watch<AssignmentsBloc>().state;
    final activeFilters = assignmentState.activeFilters;

    return CraftboxAppBar(
      title: S.current.appointments,
      backgroundColor: AppColor.white,
      leadingIconPath: assignmentsFilter,
      onLeadingIconPressed: () {
        AssignmentFilterDialog().show(context);
      },
      actions: [
        IconButton(
          icon: SvgPicture.asset(plus),
          onPressed: () {},
        ),
      ],
      bottomWidget: _buildSlider(),
      activeFilters: activeFilters
    );
  }

  PreferredSize _buildSlider() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: Container(
        alignment: Alignment.topCenter,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 18).w,
        child: BlocBuilder<SliderBloc, SliderState>(
          builder: (context, state) {
            return CraftboxSlider(
              selectedSegment: state.activeSegment,
              onValueChanged: (activeSegment) {
                context
                    .read<SliderBloc>()
                    .add(SliderSegmentChanged(activeSegment: activeSegment));

                context.read<AssignmentsBloc>().add(AssignmentsFetched(
                  isDataUpdateRequired: false,
                  activeSegment: activeSegment,
                ));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BottomBarState state) {
    switch (state.activeTab) {
      case ActiveTab.assignments:
        return _buildAssignments();
      case ActiveTab.timesheet:
        return _buildAssignments();
      case ActiveTab.more:
        return _buildMoreBody(context);
    }
  }

  Widget _buildAssignments() {
    return Builder(
      builder: (builderContext) {
        final assignmentState = builderContext.watch<AssignmentsBloc>().state;
        final activeSegment = assignmentState.activeSegment;
        final assignmentsList = assignmentState.assignments;
        final assignmentStatus = assignmentState.assignmentStatus;

        log('AssignmentsBloc. State received: $assignmentState');

        switch (assignmentStatus) {
          case Status.initial:
            builderContext.read<AssignmentsBloc>().add(AssignmentsFetched(
              isDataUpdateRequired: false,
              activeSegment: activeSegment,
            ));
            return buildLoadingIndicator();
          case Status.loading:
            return buildLoadingIndicator();
          case Status.loaded:
            return AssignmentsList(
              sliderState: activeSegment,
              assignments: assignmentsList,
            );
          case Status.error:
            return buildErrorPlaceholder(assignmentState.errorMessage);
          default:
            return AssignmentsList(
              sliderState: activeSegment,
              assignments: assignmentsList,
            );
        }
      },
    );
  }

  Widget _buildMoreBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccountSettingsList(),
            30.verticalSpace,
            _buildSupportList(),
            30.verticalSpace,
            _buildLegalList(),
            30.verticalSpace,
            _buildCraftboxBigButton(context),
            30.verticalSpace,
            _buildVersion(),
          ],
        ),
      ),
    );
  }

  CraftboxMenuList _buildAccountSettingsList() {
    return CraftboxMenuList(
      listTitle: S.current.accountSettings,
      items: [
        CraftboxMenuListItem(
          title: S.current.profile('Johns'),
          svgPicture: getFaIcon(CraftboxIcon.user),
          onItemTap: () {},
        ),
        CraftboxMenuListItem(
          title: S.current.language,
          svgPicture: getFaIcon(CraftboxIcon.earth),
          onItemTap: () {},
        ),
        CraftboxMenuListItem(
          title: S.current.changePassword,
          svgPicture: getFaIcon(CraftboxIcon.key),
          onItemTap: () {},
        ),
      ],
    );
  }

  CraftboxMenuList _buildSupportList() {
    return CraftboxMenuList(
      listTitle: S.current.support,
      items: [
        CraftboxMenuListItem(
          title: S.current.support,
          svgPicture: getFaIcon(CraftboxIcon.envelope),
          onItemTap: () {},
        ),
        CraftboxMenuListItem(
          title: S.current.sendLogs,
          svgPicture: getFaIcon(CraftboxIcon.envelope),
          onItemTap: () {},
        ),
      ],
    );
  }

  CraftboxMenuList _buildLegalList() {
    return CraftboxMenuList(
      listTitle: S.current.legal,
      items: [
        CraftboxMenuListItem(
          title: S.current.termsDialogTitle,
          svgPicture: getFaIcon(CraftboxIcon.files),
          onItemTap: () {},
        ),
        CraftboxMenuListItem(
          title: S.current.privacyPolicy,
          svgPicture: getFaIcon(CraftboxIcon.lock),
          onItemTap: () {},
        ),
        CraftboxMenuListItem(
          title: S.current.info,
          svgPicture: getFaIcon(CraftboxIcon.circleInfo),
          onItemTap: () {},
        ),
      ],
    );
  }

  CraftboxBigButton _buildCraftboxBigButton(BuildContext context) {
    return CraftboxBigButton(
      isOutlined: true,
      onPressed: () {
        sl<DialogProvider>().showPlatformSpecificDialog(
          builderContext: context,
          title: S.current.logOutTitle,
          positiveButtonTitle: S.current.logout,
          positiveButtonAction: () {
            context.read<LogoutBloc>().add(LogoutSubmitted());
            Navigator.pop(context);
          },
          negativeButtonTitle: S.current.cancel,
          negativeButtonAction: () {
            Navigator.pop(context);
          },
        );
      },
      title: S.current.logout,
    );
  }

  Text _buildVersion() {
    return Text(
      S.current.version(sl<PackageInfo>().version),
      style: TextStyle(
        fontFamily: AppFonts.latoFont,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.black,
      ),
    );
  }

  Widget _buildBottomTabBar(BuildContext context, BottomBarState state) {
    return CraftboxBottomBar(
      onItemTap: (activeTab) {
        context
            .read<BottomBarBloc>()
            .add(BottomBarTabChanged(activeTab: activeTab));
      },
      selectedIndex: state.activeTab.index,
    );
  }
}
