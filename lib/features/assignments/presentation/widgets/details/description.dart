import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common/widgets/craftbox_container.dart';
import '../../../../../core/constants/theme/colors.dart';
import '../../../../../core/constants/theme/fonts.dart';
import '../../../../../generated/l10n.dart';
import '../../../domain/entities/assignments_data_holder.dart';
import 'container_title.dart';
import 'empty_container.dart';
import 'show_more.dart';

class Description extends StatelessWidget {
  final Assignment _assignment;

  const Description({
    super.key,
    required Assignment assignment,
  }) : _assignment = assignment;

  @override
  Widget build(BuildContext context) {
    final description = _assignment.description;
    if (description.isEmpty) {
      return EmptyContainer(title: S.current.isNotAdded(S.current.description));
    }

    return CraftboxContainer(
      child: Column(
        children: [
          ContainerTitle(title: S.current.description),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17.sp,
                fontFamily: AppFonts.latoFont,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
            ),
          ),
          const ShowMore(isNumberless: true),
        ],
      ),
    );
  }
}
