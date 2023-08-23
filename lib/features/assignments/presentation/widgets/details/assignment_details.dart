import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/common/widgets/craftbox_author_info.dart';
import '../../../../../core/common/widgets/craftbox_big_button.dart';
import '../../../../../core/constants/theme/colors.dart';
import '../../../../../core/constants/theme/fonts.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../core/utils/ui_utils.dart';
import '../../../../../generated/l10n.dart';
import '../../../domain/entities/assignments_data_holder.dart';
import '../../blocs/detailed_assignment/detailed_assignment_bloc.dart';
import '../../pages/assignment_details_screen.dart';
import '../assignment_status_dialog.dart';
import 'assignment_documents.dart';
import 'assignment_resources.dart';
import 'container_title.dart';
import 'description.dart';
import 'main_assignment_info.dart';
import 'protocol_entries.dart';
import 'underline_text.dart';

class AssignmentDetails extends StatelessWidget {
  final AssignmentArguments args;
  final DetailedAssignmentState state;

  const AssignmentDetails({
    Key? key,
    required this.args,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      margin: const EdgeInsets.only(bottom: 100).h,
      child: Column(
        children: [
          _buildTitle(args, state),
          8.verticalSpace,
          _buildStatusName(args, state),
          30.verticalSpace,
          _buildChangeStatusButton(context, args, state),
          16.verticalSpace,
          _buildAssignmentDetails(args, state, context),
        ],
      ),
    );
  }

  Widget _buildTitle(AssignmentArguments args, DetailedAssignmentState state) {
    return AutoSizeText(
      state.blocStatus == Status.loaded
          ? state.assignment?.title ?? ''
          : args.title,
      style: const TextStyle(
        fontSize: 28,
        fontFamily: AppFonts.latoFont,
        fontWeight: FontWeight.w800,
        color: AppColor.white,
      ),
      maxLines: 4,
      textAlign: TextAlign.center,
      maxFontSize: 28,
      minFontSize: 17,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text _buildStatusName(
    AssignmentArguments args,
    DetailedAssignmentState state,
  ) {
    final assignment = state.assignment;
    String statusName = args.inAppAssignmentState.name;
    if (state.blocStatus == Status.loaded && assignment != null) {
      final loadedState = assignment.state;
      statusName = loadedState.inAppState.name;
    }

    return Text(
      statusName,
      style: TextStyle(
        fontSize: 15.sp,
        fontFamily: AppFonts.latoFont,
        fontWeight: FontWeight.w500,
        color: AppColor.white,
      ),
    );
  }

  CraftboxBigButton _buildChangeStatusButton(
    BuildContext context,
    AssignmentArguments args,
    DetailedAssignmentState state,
  ) {
    return CraftboxBigButton(
      onPressed: () async {
        if (state.blocStatus == Status.loaded) {
          final isDataRefreshRequired =
              await AssignmentStatusDialog().show(context);
          if (context.mounted && (isDataRefreshRequired as bool? ?? false)) {
            Future.delayed(const Duration(milliseconds: 500), () {
              context
                  .read<DetailedAssignmentBloc>()
                  .add(DetailedAssignmentFetched(assignmentId: args.id));
            });
          }
        }
      },
      title: S.current.changeStatus,
      backgroundColor: _getChangeStatusButtonColor(state, args),
      height: 46,
      borderRadius: 10,
    );
  }

  Color _getChangeStatusButtonColor(
    DetailedAssignmentState state,
    AssignmentArguments args,
  ) {
    final assignment = state.assignment;
    Color color = args.inAppAssignmentState.buttonColor;
    if (state.blocStatus == Status.loaded && assignment != null) {
      color = assignment.state.inAppState.buttonColor;
    }
    return color;
  }

  Widget _buildAssignmentDetails(
    AssignmentArguments args,
    DetailedAssignmentState state,
    BuildContext context,
  ) {
    switch (state.blocStatus) {
      case Status.loaded:
        return _buildAvailableData(state.assignment, context);
      case Status.error:
        return buildErrorPlaceholder(state.errorMsg);
      case Status.initial:
        context
            .read<DetailedAssignmentBloc>()
            .add(DetailedAssignmentFetched(assignmentId: args.id));
        return buildLoadingIndicator();
      default:
        return buildLoadingIndicator();
    }
  }

  Widget _buildAvailableData(
    Assignment? assignment,
    BuildContext context,
  ) {
    if (assignment == null) {
      return buildErrorPlaceholder(S.current.assignmentLoadingError);
    }

    return Column(
      children: [
        MainAssignmentInfo(assignment: assignment),
        AssignmentResources(assignment: assignment),
        Description(assignment: assignment),
        AssignmentDocuments(assignment: assignment),
        10.verticalSpace,
        _buildProtocolEntryHeader(),
        15.verticalSpace,
        const ProtocolEntries(),
        30.verticalSpace,
        _buildFooter(context, assignment),
      ],
    );
  }

  SizedBox _buildProtocolEntryHeader() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ContainerTitle(
            title: S.current.protocolEntry,
            padding: null,
            width: null,
          ),
          UnderlineText(
            textToShow: S.current.viewAll,
            padding: null,
            width: null,
          ),
        ],
      ),
    );
  }

  CraftboxAuthorInfo _buildFooter(BuildContext context, Assignment assignment) {
    final updatedAt = CraftboxDateTimeUtils.getFormattedDate(
      context,
      assignment.updatedAt,
      isDateWithTimeRequired: true,
    );

    final causer = assignment.creation?.causer;

    return CraftboxAuthorInfo(
      text: S.current.updated,
      causer: causer,
      updatedAtDate: updatedAt,
    );
  }
}
