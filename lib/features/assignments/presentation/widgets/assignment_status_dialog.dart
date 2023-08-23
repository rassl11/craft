import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/assignments_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/dialog_provider.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/assignments_data_holder.dart';
import '../blocs/detailed_assignment/detailed_assignment_bloc.dart';
import '../pages/time_recorder_screen.dart';
import 'craftbox_list_divider.dart';

class AssignmentStatusDialog {
  Future<Object?> show(BuildContext context) {
    return showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,) {
          return Scaffold(
            body: BlocProvider.value(
              value: BlocProvider.of<DetailedAssignmentBloc>(context),
              child:
              BlocConsumer<DetailedAssignmentBloc, DetailedAssignmentState>(
                listener: (context, state) {
                  _handleAssignmentSelectionStatus(
                    context: context,
                    state: state,
                  );
                },
                builder: (builderContext, state) {
                  return _buildStatesContainer(
                    builderContext: builderContext,
                    state: state,
                  );
                },
              ),
            ),
          );
        });
  }

  void _handleAssignmentSelectionStatus({
    required BuildContext context,
    required DetailedAssignmentState state,
  }) {
    switch (state.assignmentSelectionStatus) {
      case Status.error:
        showSnackBarWithText(context, state.errorMsg);
        break;
      case Status.loaded:
        _handleSelectedAssignmentState(
          context: context,
          state: state,
        );
        break;
      default:
        break;
    }
  }

  Container _buildStatesContainer({
    required BuildContext builderContext,
    required DetailedAssignmentState state,
  }) {
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
          _buildTitleBar(builderContext),
          _buildStatesList(builderContext, state)
        ],
      ),
    );
  }

  void _handleSelectedAssignmentState({
    required BuildContext context,
    required DetailedAssignmentState state,
  }) {
    switch (state.selectedAssignmentState) {
      case InAppAssignmentState.paused:
      case InAppAssignmentState.done:
        if (state.totalTimeHolder.isNotEmpty) {
          final workingTime = CraftboxDateTimeUtils.formatTime(
              state.totalTimeHolder.workingTime);
          sl<DialogProvider>().showTimeDialog(
            builderContext: context,
            content: S.current.timeDialogContent(workingTime),
            onRecordMoreTime: () => _showTimeRecorderScreen(context, state),
            onChangeStatusOnly: () => Navigator.of(context).pop(),
          );
        } else {
          _showTimeRecorderScreen(context, state);
        }
        break;
      default:
        Navigator.of(context).pop();
        break;
    }
  }

  Container _buildTitleBar(BuildContext context) {
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
        S.current.changeStatusTitle,
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

  Widget _buildStatesList(BuildContext context, DetailedAssignmentState state) {
    return Stack(
      children: [
        Padding(
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
              children: [..._buildStateTiles(context, state)],
            ),
          ),
        ),
        if (state.assignmentSelectionStatus == Status.loading)
          SizedBox(
            width: double.infinity,
            height: 1.sh - (1.sh * 0.3),
            child: buildLoadingIndicator(),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  List<Widget> _buildStateTiles(
    BuildContext context,
    DetailedAssignmentState state,
  ) {
    final assignment = state.assignment;
    if (assignment == null) {
      return [];
    }

    final List<Widget> stateTiles = [];
    for (final availableState in availableStates) {
      final isRadioChecked = _isRadioChecked(assignment, availableState, state);
      final filterTile = _buildStateTile(
        isChecked: isRadioChecked,
        inAppState: availableState,
        onTap: () {
          _handleStateTap(
            isRadioChecked: isRadioChecked,
            context: context,
            availableState: availableState,
            assignment: assignment,
          );
        },
      );

      stateTiles
        ..add(filterTile)..add(const CraftboxListDivider());
    }

    if (stateTiles.isNotEmpty) {
      stateTiles.removeLast();
    }

    return stateTiles;
  }

  void _handleStateTap({
    required bool isRadioChecked,
    required BuildContext context,
    required InAppAssignmentState availableState,
    required Assignment assignment,
  }) {
    if (!isRadioChecked) {
      switch (availableState) {
        case InAppAssignmentState.scheduled:
        case InAppAssignmentState.inProgress:
        case InAppAssignmentState.done:
        case InAppAssignmentState.paused:
          context.read<DetailedAssignmentBloc>().add(
            AssignmentStatusSelected(
              assignmentId: assignment.id,
              selectedAssignmentState: availableState,
            ),
          );
          break;
        case InAppAssignmentState.actionRequired:
        case InAppAssignmentState.notScheduled:
        case InAppAssignmentState.unsupported:
          break;
      }
    }
  }

  void _showTimeRecorderScreen(BuildContext context,
      DetailedAssignmentState state,) {
    Navigator.pushNamed(
      context,
      TimeRecordsScreen.routeName,
      arguments: TimeRecorderScreenArgs(
        assignmentId: state.assignment!.id,
        totalTimeRecorded: state.totalTimeHolder,
      ),
    );
  }

  bool _isRadioChecked(Assignment assignment,
      InAppAssignmentState inAppState,
      DetailedAssignmentState state,) {
    bool isRadioChecked =
        assignment.state == inAppState.originalAssignmentState;
    switch (state.assignmentSelectionStatus) {
      case Status.loading:
      case Status.loaded:
        final selectedAssignmentState = state.selectedAssignmentState;
        if (selectedAssignmentState != null) {
          isRadioChecked = selectedAssignmentState.originalAssignmentState ==
              inAppState.originalAssignmentState;
        }
        break;
      case Status.initial:
      case Status.error:
        isRadioChecked = assignment.state == inAppState.originalAssignmentState;
        break;
    }
    return isRadioChecked;
  }

  Widget _buildStateTile({
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
      leading: SizedBox(
        width: 24,
        height: 24,
        child: Transform.scale(
          scale: 1.5,
          child: Radio<InAppAssignmentState>(
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            activeColor: inAppState.bgColor,
            fillColor: MaterialStateProperty.all(inAppState.bgColor),
            overlayColor: MaterialStateProperty.all(inAppState.bgColor),
            value: inAppState,
            groupValue: isChecked ? inAppState : null,
            onChanged: (_) {
              onTap();
            },
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
