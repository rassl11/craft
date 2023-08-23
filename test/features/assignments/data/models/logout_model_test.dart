import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:share/features/assignments/data/models/logout_model.dart';
import 'package:share/features/assignments/domain/entities/logout.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const String tSuccess = 'success';
  const tLogoutModel = LogoutModel(success: tSuccess);

  test(
    'should be a subclass of Logout entity',
    () async {
      // assert
      expect(tLogoutModel, isA<Logout>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid LogoutModel',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('login/logout.json')) as Map<String, dynamic>;
        // act
        final result = LogoutModel.fromJson(jsonMap);
        // assert
        expect(result, tLogoutModel);
      },
    );
  });
}
