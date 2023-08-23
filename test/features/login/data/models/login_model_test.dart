import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:share/features/login/data/models/login_model.dart';
import 'package:share/features/login/domain/entities/login.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const String tAccessToken = 'accessToken';
  const String tTokenType = 'tokenType';
  const tLoginModel =
      LoginModel(accessToken: tAccessToken, tokenType: tTokenType);

  test(
    'should be a subclass of Login entity',
    () async {
      // assert
      expect(tLoginModel, isA<Login>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid LoginModel',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('login/login.json')) as Map<String, dynamic>;
        // act
        final result = LoginModel.fromJson(jsonMap);
        // assert
        expect(result, tLoginModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tLoginModel.toJson();
        // assert
        final expectedMap = {
          'access_token': tAccessToken,
          'token_type': tTokenType,
        };
        expect(result, expectedMap);
      },
    );
  });
}
