import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/craftbox_container.dart';
import '../../../../../core/constants/theme/images.dart';
import '../../../../../generated/l10n.dart';
import '../../../domain/entities/assignments_data_holder.dart';
import '../../../domain/entities/tool.dart';
import '../../../domain/entities/vehicle.dart';
import '../assignment_list_item.dart';
import '../craftbox_list_divider.dart';
import 'container_title.dart';
import 'empty_container.dart';
import 'show_more.dart';

class AssignmentResources extends StatelessWidget {
  final Assignment _assignment;

  const AssignmentResources({Key? key, required Assignment assignment})
      : _assignment = assignment,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicles = _assignment.vehicles;
    final tools = _assignment.tools;
    final visibleResources = _getVisibleResourcesList(vehicles, tools);
    final totalResources = (vehicles?.length ?? 0) + (tools?.length ?? 0);
    final hiddenResources =
        totalResources == 0 ? 0 : totalResources - visibleResources.length;

    if (visibleResources.isEmpty) {
      return EmptyContainer(title: S.current.areNotAdded(S.current.resources));
    }

    return CraftboxContainer(
        child: Column(
      children: [
        ContainerTitle(title: S.current.resources),
        ...visibleResources,
        ShowMore(numberOfHiddenDocuments: hiddenResources),
      ],
    ));
  }

  List<Widget> _getVisibleResourcesList(
    List<Vehicle>? vehicles,
    List<Tool>? tools,
  ) {
    final List<Widget> resources = [];
    for (final Vehicle vehicle in vehicles ?? []) {
      resources.addAll([
        _buildVehicle(vehicle),
        const CraftboxListDivider(),
      ]);

      break;
    }

    for (final Tool tool in tools ?? []) {
      if (resources.length >= 3) {
        break;
      }
      resources.addAll([
        _buildTool(tool),
        const CraftboxListDivider(),
      ]);
    }

    if (resources.isNotEmpty) {
      resources.removeLast();
    }

    return resources;
  }

  AssignmentListItem _buildVehicle(Vehicle vehicle) {
    return AssignmentListItem(
      text: '${vehicle.manufacturer} ${vehicle.model} '
          '(${vehicle.licensePlate})',
      svgPicture: getFaIconByString(vehicle.icon),
      isTrailingArrowEnabled: true,
    );
  }

  AssignmentListItem _buildTool(Tool tool) {
    return AssignmentListItem(
      text: '${tool.manufacturer} ${tool.model}',
      svgPicture: getFaIconByString(tool.icon),
      isTrailingArrowEnabled: true,
    );
  }
}
