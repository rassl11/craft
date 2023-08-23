import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:share/features/login/data/models/forgot_password_model.dart';
import 'package:share/features/login/domain/entities/forgot_password.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const String tSuccess = 'success';
  const tForgotPasswordModel = ForgotPasswordModel(success: tSuccess);

  test(
    'should be a subclass of ForgotPassword entity',
    () async {
      // assert
      expect(tForgotPasswordModel, isA<ForgotPassword>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid ForgotPasswordModel',
      () async {
        // arrange
        final payload = fixture('login/forgot_password.json');
        final Map<String, dynamic> jsonMap =
            json.decode(payload) as Map<String, dynamic>;
        // act
        final result = ForgotPasswordModel.fromJson(jsonMap);
        // assert
        expect(result, tForgotPasswordModel);
      },
    );
  });
}
