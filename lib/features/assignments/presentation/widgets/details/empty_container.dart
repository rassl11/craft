import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/craftbox_container.dart';
import '../../../../../core/constants/theme/colors.dart';
import 'container_title.dart';

class EmptyContainer extends StatelessWidget {
  final String _title;

  const EmptyContainer({
    super.key,
    required String title,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    return CraftboxContainer(
      child: ContainerTitle(
        title: _title,
        textColor: AppColor.gray400,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
