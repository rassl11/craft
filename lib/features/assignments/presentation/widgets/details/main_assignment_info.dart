import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common/widgets/craftbox_container.dart';
import '../../../../../core/common/widgets/craftbox_tags_holder.dart';
import '../../../../../core/constants/theme/colors.dart';
import '../../../../../core/constants/theme/fonts.dart';
import '../../../../../core/constants/theme/images.dart';
import '../../../../../core/utils/assignments_utils.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../generated/l10n.dart';
import '../../../domain/entities/assignments_data_holder.dart';
import '../assignment_list_item.dart';
import '../craftbox_list_divider.dart';

class MainAssignmentInfo extends StatelessWidget {
  final Assignment _assignment;

  const MainAssignmentInfo({Key? key, required Assignment assignment})
      : _assignment = assignment,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CraftboxContainer(
      child: Column(
        children: _getAssignmentInfoItems(_assignment, context),
      ),
    );
  }

  List<Widget> _getAssignmentInfoItems(
    Assignment assignment,
    BuildContext context,
  ) {
    final List<Widget> items = [
      _buildMainAssignmentInfoNote(assignment.internalNote),
      AssignmentListItem(
        text: assignment.project?.title ?? '-=-',
        svgPicture: getFaIcon(CraftboxIcon.clipboard),
        isTrailingArrowEnabled: true,
      ),
      const CraftboxListDivider(),
      AssignmentListItem(
        text: assignment.customerAddress?.name ?? '-=-',
        svgPicture: getFaIcon(CraftboxIcon.phone),
        isTrailingArrowEnabled: true,
      ),
      const CraftboxListDivider(),
      AssignmentListItem(
        text: getAddress(assignment),
        svgPicture: getFaIcon(CraftboxIcon.locationDot),
        isTrailingArrowEnabled: true,
      ),
      const CraftboxListDivider(),
    ];

    if (assignment.start != null) {
      items.addAll(_buildScheduledTime(context, assignment));
    }

    items.add(_buildAssigners(assignment));

    if (assignment.tags.isNotEmpty) {
      items.addAll([
        const CraftboxListDivider(),
        CraftboxTagsHolder(assignment: assignment),
      ]);
    }

    items.add(const SizedBox(height: 8));

    return items;
  }

  Container _buildMainAssignmentInfoNote(String internalNote) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.accent50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        internalNote.isNotEmpty ? internalNote : '-=-',
        style: TextStyle(
          fontSize: 17.sp,
          fontFamily: AppFonts.latoFont,
          fontWeight: FontWeight.w600,
          color: AppColor.accent400,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  List<StatelessWidget> _buildScheduledTime(
    BuildContext context,
    Assignment assignment,
  ) {
    return [
      AssignmentListItem(
        text: CraftboxDateTimeUtils.getScheduledPeriodOfTime(
          context,
          assignment,
        ),
        svgPicture: getFaIcon(CraftboxIcon.bell),
      ),
      const CraftboxListDivider(),
    ];
  }

  Widget _buildAssigners(Assignment assignment) {
    return AssignmentListItem(
      text: S.current.assigners,
      svgPicture: getFaIcon(CraftboxIcon.worker),
      isTrailingArrowEnabled: true,
      assigners: assignment.employees,
    );
  }
}
