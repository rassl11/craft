import 'package:flutter/material.dart';

import '../../features/assignments/domain/entities/documentation.dart';
import '../../features/protocol/presentation/pages/protocol_screen.dart';
import '../../generated/l10n.dart';
import 'date_utils.dart';

class ProtocolUtils {
  static Map<String, String> parseMaterials(String? description) {
    final Map<String, String> parsedMap = {};
    if (description == null) {
      return parsedMap;
    }

    final List<String> parsedByN = description.split('\n');
    for (final element in parsedByN) {
      final List<String> parsedByQuote = element.split('"');
      final List<String> cleanedElements = parsedByQuote
          .map((e) => e.replaceAll('\n', '').trim())
          .toList()
        ..removeWhere((element) => element.isEmpty);
      parsedMap[cleanedElements.last] = cleanedElements.first;
    }

    return parsedMap;
  }

  static List<DocumentationItemData> getProtocolDataItems(
    BuildContext context,
    List<Documentation> documentations,
  ) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final List<DocumentationItemData> items = [];
    String previousAddedDate = '';
    for (final documentation in documentations) {
      final createdAt = documentation.createdAt;
      if (createdAt == null) {
        continue;
      }

      final timeZoneOffset = now.timeZoneOffset;
      final createdAtWithOffset = createdAt.add(timeZoneOffset);
      final createdAtDate = DateTime(
        createdAtWithOffset.year,
        createdAtWithOffset.month,
        createdAtWithOffset.day,
      );
      final currentDateString = CraftboxDateTimeUtils.getFormattedDate(
        context,
        createdAt,
      );
      final dividerDate =
          createdAtDate == todayDate ? S.current.today : currentDateString;
      if (previousAddedDate.isEmpty || previousAddedDate != dividerDate) {
        items.add(
          DocumentationItemData(
            date: dividerDate,
            documentation: documentation,
          ),
        );
        previousAddedDate = dividerDate;
      } else {
        items.add(DocumentationItemData(documentation: documentation));
      }
    }
    return items;
  }
}
