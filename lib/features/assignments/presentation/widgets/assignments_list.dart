import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_tags_holder.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/utils/assignments_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/assignments_data_holder.dart';
import '../blocs/assignments/assignments_bloc.dart';
import '../pages/assignment_details_screen.dart';
import 'assignment_list_item.dart';
import 'craftbox_list_divider.dart';
import 'craftbox_slider.dart';

class AssignmentsList extends StatelessWidget {
  final ActiveSegment sliderState;
  final List<Assignment> assignments;

  const AssignmentsList({
    Key? key,
    required this.sliderState,
    required this.assignments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: RefreshIndicator(
        onRefresh: () async {
          final assignmentsBloc = context.read<AssignmentsBloc>()
            ..add(
              AssignmentsFetched(
                isDataUpdateRequired: true,
                activeSegment: sliderState,
              ),
            );
          return _onListRefresh(assignmentsBloc);
        },
        child: assignments.isEmpty
            ? _buildEmptyAssignmentsPlaceholder()
            : ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (itemBuilderContext, index) {
                  final assignment = assignments[index];
                  return _buildAssignment(
                    sliderState,
                    itemBuilderContext,
                    assignment,
                  );
                },
              ),
      ),
    );
  }

  Future<void> _onListRefresh(AssignmentsBloc assignmentsBloc) async {
    await assignmentsBloc.stream.firstWhere((state) {
      return state.assignmentStatus == Status.loaded;
    });
  }

  Widget _buildEmptyAssignmentsPlaceholder() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          primary: true,
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    SvgPicture.asset(assignmentsEmptyListLogo),
                    50.verticalSpace,
                    Text(
                      S.current.defaultBodyTitle,
                      style: TextStyle(
                        fontFamily: AppFonts.latoFont,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColor.black,
                      ),
                    ),
                    20.verticalSpace,
                    Text(
                      S.current.defaultBodyDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.latoFont,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssignment(
    ActiveSegment sliderState,
    BuildContext context,
    Assignment assignment,
  ) {
    final inAppAssignmentState = assignment.state.inAppState;
    final assignmentDate = sliderState == ActiveSegment.sinceToday
        ? ''
        : CraftboxDateTimeUtils.getFormattedDate(context, assignment.start);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        _showAssignmentDetailsScreen(
          context,
          assignment,
          inAppAssignmentState,
          sliderState,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            _buildAssignmentHeader(assignmentDate),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2),
              ),
              child: Column(
                children: [
                  _buildAssignmentTitle(
                      assignment, inAppAssignmentState.bgColor),
                  _buildAssignmentBody(context, assignment)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Object?> _showAssignmentDetailsScreen(
    BuildContext context,
    Assignment assignment,
    InAppAssignmentState inAppAssignmentState,
    ActiveSegment sliderState,
  ) async {
    final isRefreshRequired = await Navigator.pushNamed(
      context,
      AssignmentDetailsScreen.routeName,
      arguments: AssignmentArguments(
        id: assignment.id,
        title: assignment.title,
        inAppAssignmentState: inAppAssignmentState,
      ),
    );

    if (context.mounted && (isRefreshRequired as bool? ?? false)) {
      context.read<AssignmentsBloc>().add(AssignmentsFetched(
            isDataUpdateRequired: true,
            activeSegment: sliderState,
          ));
    }

    return isRefreshRequired;
  }

  ListTile _buildAssignmentHeader(String assignmentDate) {
    return ListTile(
      title: Align(
        alignment: const Alignment(0.2, 0),
        child: Text(
          assignmentDate,
          style: TextStyle(
            fontFamily: AppFonts.latoFont,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      trailing: const Icon(
        Icons.more_horiz_sharp,
        color: AppColor.black,
      ),
    );
  }

  ListTile _buildAssignmentTitle(Assignment assignment, Color tileColor) {
    return ListTile(
      title: Text(
        assignment.title,
        style: TextStyle(
          color: AppColor.white,
          fontFamily: AppFonts.latoFont,
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
      tileColor: tileColor,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColor.white,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
    );
  }

  Container _buildAssignmentBody(BuildContext context, Assignment assignment) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        children: [
          ..._getAssignmentDataList(context, assignment),
          CraftboxTagsHolder(assignment: assignment),
        ],
      ),
    );
  }

  List<Widget> _getAssignmentDataList(
    BuildContext context,
    Assignment assignment,
  ) {
    final body = [
      AssignmentListItem(
        text: assignment.customerAddress?.name ?? '-=-',
        svgPicture: getFaIcon(CraftboxIcon.phone),
      ),
      const CraftboxListDivider(),
      AssignmentListItem(
        text: getAddress(assignment),
        svgPicture: getFaIcon(CraftboxIcon.locationDot),
      ),
    ];

    if (assignment.start != null) {
      final String scheduledPeriodOfTime =
      CraftboxDateTimeUtils.getScheduledPeriodOfTime(
        context,
        assignment,
      );
      body.addAll([
        const CraftboxListDivider(),
        AssignmentListItem(
          text: scheduledPeriodOfTime,
          svgPicture: getFaIcon(CraftboxIcon.bell),
        ),
      ]);
    }

    return body;
  }
}
