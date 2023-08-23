import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/utils/form_validator.dart';
import 'package:share/features/login/domain/entities/forgot_password.dart';
import 'package:share/features/login/domain/usecases/post_forgot_password.dart';
import 'package:share/features/login/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:share/generated/l10n.dart';

class MockPostForgotPassword extends Mock implements PostForgotPassword {}

class MockFormValidator extends Mock implements FormValidator {}

void main() async {
  await S.load(const Locale.fromSubtags(languageCode: 'en'));

  late MockPostForgotPassword mockPostForgotPassword;
  late MockFormValidator mockFormValidator;
  late ForgotPasswordBloc forgotPasswordBloc;

  setUpAll(() {
    registerFallbackValue(const ForgotPasswordParams(''));
  });

  setUp(() {
    mockPostForgotPassword = MockPostForgotPassword();
    mockFormValidator = MockFormValidator();
    forgotPasswordBloc = ForgotPasswordBloc(
      postForgotPassword: mockPostForgotPassword,
      formValidator: mockFormValidator,
    );
  });

  test('initial forgotPasswordStatus should be ForgotPasswordStatus.initial',
      () {
    // assert
    expect(
      forgotPasswordBloc.state.forgotPasswordStatus,
      equals(ForgotPasswordStatus.initial),
    );
  });

  group('EmailChanged', () {
    const tEmail = 'email';
    test(
        'should emit [ForgotPasswordState] with the email and '
        'its validationStatus', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(false);
      // act
      forgotPasswordBloc.add(const EmailChanged(email: tEmail));
      // assert
      final expectedOrder = [
        const ForgotPasswordState(
          email: tEmail,
          isEmailValid: false,
        ),
      ];
      await expectLater(forgotPasswordBloc.stream, emitsInOrder(expectedOrder));
      verify(() => mockFormValidator.isUsernameValid(tEmail));
      verifyNoMoreInteractions(mockFormValidator);
    });
  });

  group('EmailFieldFocused', () {
    test('should reset email text field error on focus', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(false);
      // act
      forgotPasswordBloc.add(EmailFieldFocused());
      // assert
      final expectedOrder = [
        const ForgotPasswordState(
          isEmailValid: true,
        ),
      ];
      await expectLater(forgotPasswordBloc.stream, emitsInOrder(expectedOrder));
    });
  });

  group('ForgotPasswordSubmitted', () {
    test(
        'should return ForgotPasswordStatus.success if '
        'email is valid', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(true);
      when(() => mockPostForgotPassword.call(any()))
          .thenAnswer((_) async => const Right(
                ForgotPassword(success: 'success'),
              ));
      // act
      forgotPasswordBloc.add(EmailSubmitted());
      // assert
      final expectedOrder = [
        const ForgotPasswordState(
          forgotPasswordStatus: ForgotPasswordStatus.loading,
        ),
        const ForgotPasswordState(
          forgotPasswordStatus: ForgotPasswordStatus.success,
        ),
      ];
      await expectLater(forgotPasswordBloc.stream, emitsInOrder(expectedOrder));
    });

    test(
        'should return ForgotPasswordStatus.failure with error message if '
        'postForgot password usecase fails', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(true);
      when(() => mockPostForgotPassword.call(any()))
          .thenAnswer((_) async => Left(InternetConnectionFailure()));
      // act
      forgotPasswordBloc.add(EmailSubmitted());
      // assert
      final expectedOrder = [
        const ForgotPasswordState(
          forgotPasswordStatus: ForgotPasswordStatus.loading,
        ),
        const ForgotPasswordState(
            forgotPasswordStatus: ForgotPasswordStatus.failure,
            errorMessage: 'No internet connection'),
      ];
      await expectLater(forgotPasswordBloc.stream, emitsInOrder(expectedOrder));
    });

    test('should return ForgotPasswordStatus.failure if email is invalid',
        () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(false);
      // act
      forgotPasswordBloc.add(EmailSubmitted());
      // assert
      final expectedOrder = [
        const ForgotPasswordState(
          forgotPasswordStatus: ForgotPasswordStatus.loading,
        ),
        const ForgotPasswordState(
          forgotPasswordStatus: ForgotPasswordStatus.failure,
          errorMessage: 'Please enter a valid email address',
        ),
      ];
      await expectLater(forgotPasswordBloc.stream, emitsInOrder(expectedOrder));
      verifyZeroInteractions(mockPostForgotPassword);
    });
  });
}
