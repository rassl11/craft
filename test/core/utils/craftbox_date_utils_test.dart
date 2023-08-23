import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share/core/utils/date_utils.dart';
import 'package:share/generated/l10n.dart';

void main() async {
  final strings = await S.load(const Locale.fromSubtags(languageCode: 'en'));

  group('formatTime', () {
    test('should return -- h -- m if minutes == 0', () async {
      // arrange
      const minutes = 0;
      final expected = strings.timePlaceholder;
      // act
      final result = CraftboxDateTimeUtils.formatTime(minutes);
      // assert
      expect(result, expected);
    });

    test('should return 2h 0m if minutes == 120', () async {
      // arrange
      const minutes = 120;
      const expected = '2h 0m';
      // act
      final result = CraftboxDateTimeUtils.formatTime(minutes);
      // assert
      expect(result, expected);
    });

    test('should return 0h 30m if minutes == 30', () async {
      // arrange
      const minutes = 30;
      const expected = '0h 30m';
      // act
      final result = CraftboxDateTimeUtils.formatTime(minutes);
      // assert
      expect(result, expected);
    });

    test('should return 1h 15m if minutes == 75', () async {
      // arrange
      const minutes = 75;
      const expected = '1h 15m';
      // act
      final result = CraftboxDateTimeUtils.formatTime(minutes);
      // assert
      expect(result, expected);
    });
  });
}
