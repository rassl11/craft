import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/core/utils/form_validator.dart';
import 'package:share/features/login/domain/entities/login.dart';
import 'package:share/features/login/domain/usecases/login_user.dart';
import 'package:share/features/login/presentation/blocs/login/login_bloc.dart';
import 'package:share/generated/l10n.dart';

class MockLoginUser extends Mock implements LoginUser {}

class MockFormValidator extends Mock implements FormValidator {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() async {
  await S.load(const Locale.fromSubtags(languageCode: 'en'));

  late MockLoginUser mockLoginUser;
  late MockFormValidator mockFormValidator;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late LoginBloc loginBloc;

  setUpAll(() {
    registerFallbackValue(const LoginParams(password: '', email: ''));
  });

  setUp(() {
    mockLoginUser = MockLoginUser();
    mockFormValidator = MockFormValidator();
    mockAuthenticationRepository = MockAuthenticationRepository();
    loginBloc = LoginBloc(
      loginUser: mockLoginUser,
      formValidator: mockFormValidator,
      authenticationRepository: mockAuthenticationRepository,
    );
  });

  test('initial loginStatus should be LoginStatus.initial', () {
    // assert
    expect(loginBloc.state.loginStatus, equals(LoginStatus.initial));
  });

  group('LoginPasswordVisibilityToggled', () {
    test('should emit [LoginState] with the inverted isPasswordVisible',
        () async {
      // act
      loginBloc.add(LoginPasswordVisibilityToggled());
      // assert
      final expectedOrder = [
        const LoginState(
          isPasswordVisible: true,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verifyNoMoreInteractions(mockFormValidator);
    });
  });

  group('LoginSwitcherToggled', () {
    test(
        'should emit [LoginState] with termsState: TermsState.dialogCalled and '
        'loginStatus: LoginStatus.initial if TermsState is initial, '
        'rejected or dialogCalled', () async {
      // act
      loginBloc.add(LoginSwitcherToggled());
      // assert
      final expectedOrder = [
        const LoginState(
          termsState: TermsState.accepted,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
    });

    test(
        'should emit [LoginState] with termsState: TermsState.rejected and'
        ' loginStatus: LoginStatus.initial if TermsState is accepted',
        () async {
      // act
      loginBloc
        ..add(LoginSwitcherToggled())
        ..add(LoginSwitcherToggled());
      // assert
      final expectedOrder = [
        const LoginState(
          termsState: TermsState.accepted,
        ),
        const LoginState(
          termsState: TermsState.rejected,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
    });
  });

  group('LoginTermsAccepted', () {
    test(
        'should emit [LoginState] with termsState: TermsState.accepted and '
        'add LoginSubmitted event', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(true);
      when(() => mockFormValidator.isPasswordValid(any())).thenReturn(true);
      when(() => mockLoginUser.call(any())).thenAnswer((_) async =>
          const Right(Login(accessToken: 'token', tokenType: 'type')));
      when(() => mockAuthenticationRepository.logIn(token: any(named: 'token')))
          .thenAnswer((_) async => true);
      // act
      loginBloc.add(LoginTermsAccepted());
      // assert
      final expectedOrder = [
        const LoginState(
          termsState: TermsState.accepted,
        ),
        const LoginState(
          loginStatus: LoginStatus.loading,
          termsState: TermsState.accepted,
        ),
        const LoginState(loginStatus: LoginStatus.success),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
    });
  });

  group('LoginTermsRejected', () {
    test('should emit [LoginState] with termsState: TermsState.rejected',
        () async {
      // act
      loginBloc.add(LoginTermsRejected());
      // assert
      final expectedOrder = [
        const LoginState(
          termsState: TermsState.rejected,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
    });
  });

  group('LoginFieldFocused', () {
    test('should hide an error on the login text field', () async {
      // act
      loginBloc.add(LoginFieldFocused());
      // assert
      final expectedOrder = [
        const LoginState(
          isUsernameValid: true,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
    });
  });

  group('PasswordFieldFocused', () {
    test('should hide an error on the password text field', () async {
      // act
      loginBloc.add(PasswordFieldFocused());
      // assert
      final expectedOrder = [
        const LoginState(
          isPasswordValid: true,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
    });
  });

  group('LoginUsernameChanged', () {
    const tUsername = 'username';
    test(
        'should emit [LoginState] with the username and '
        'its validationStatus', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(false);
      // act
      loginBloc.add(const LoginUsernameChanged(username: tUsername));
      // assert
      final expectedOrder = [
        const LoginState(
          username: tUsername,
          isUsernameValid: false,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verify(() => mockFormValidator.isUsernameValid(tUsername));
      verifyNoMoreInteractions(mockFormValidator);
    });
  });

  group('LoginPasswordChanged', () {
    const tPassword = 'password';

    test(
        'should emit [LoginState] with the password and'
        ' its validationStatus', () async {
      // arrange
      when(() => mockFormValidator.isPasswordValid(any())).thenReturn(false);
      // act
      loginBloc.add(const LoginPasswordChanged(password: tPassword));
      // assert
      final expectedOrder = [
        const LoginState(
          password: tPassword,
          isPasswordValid: false,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verify(() => mockFormValidator.isPasswordValid(tPassword));
      verifyNoMoreInteractions(mockFormValidator);
    });
  });

  group('LoginSubmitted', () {
    test(
        'should return [LoginState] with LoginStatus.success if '
        'form is valid and terms accepted', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(true);
      when(() => mockFormValidator.isPasswordValid(any())).thenReturn(true);
      when(() => mockLoginUser.call(any())).thenAnswer((_) async =>
          const Right(Login(accessToken: 'token', tokenType: 'type')));
      when(() => mockAuthenticationRepository.logIn(token: any(named: 'token')))
          .thenAnswer((_) async => true);
      // act
      loginBloc
        ..add(LoginTermsAccepted())
        ..add(LoginSubmitted());
      // assert
      final expectedOrder = [
        const LoginState(termsState: TermsState.accepted),
        const LoginState(
          loginStatus: LoginStatus.loading,
          termsState: TermsState.accepted,
        ),
        const LoginState(loginStatus: LoginStatus.success),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verify(
          () => mockAuthenticationRepository.logIn(token: any(named: 'token')));
    });

    test(
        'should return [LoginState] with LoginStatus.failure if login '
        'user usecase fails', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(true);
      when(() => mockFormValidator.isPasswordValid(any())).thenReturn(true);
      when(() => mockLoginUser.call(any()))
          .thenAnswer((_) async => Left(InternetConnectionFailure()));
      // act
      loginBloc
        ..add(LoginTermsAccepted())
        ..add(LoginSubmitted());
      // assert
      final expectedOrder = [
        const LoginState(termsState: TermsState.accepted),
        const LoginState(
          loginStatus: LoginStatus.loading,
          termsState: TermsState.accepted,
        ),
        const LoginState(
          loginStatus: LoginStatus.failure,
          termsState: TermsState.accepted,
          errorMessage: 'No internet connection',
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verifyZeroInteractions(mockAuthenticationRepository);
    });

    test(
        'should return [LoginState] with TermsState.dialogCalled if '
        'terms was not accepted', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(true);
      when(() => mockFormValidator.isPasswordValid(any())).thenReturn(true);
      // act
      loginBloc.add(LoginSubmitted());
      // assert
      final expectedOrder = [
        const LoginState(
          termsState: TermsState.dialogCalled,
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verifyZeroInteractions(mockAuthenticationRepository);
    });

    test(
        'should return [LoginState] with LoginStatus.failure, '
        'isUsernameValid: false and isPasswordValid: true if '
        'username is invalid', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(false);
      when(() => mockFormValidator.isPasswordValid(any())).thenReturn(true);
      // act
      loginBloc.add(LoginSubmitted());
      // assert
      final expectedOrder = [
        const LoginState(
          isUsernameValid: false,
          isPasswordValid: true,
          loginStatus: LoginStatus.failure,
          errorMessage: 'Please, enter valid credentials',
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verifyZeroInteractions(mockLoginUser);
      verifyZeroInteractions(mockAuthenticationRepository);
    });

    test(
        'should return [LoginState] with LoginStatus.failure, '
        'isUsernameValid: true and isPasswordValid: false if '
        'password is invalid', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(true);
      when(() => mockFormValidator.isPasswordValid(any())).thenReturn(false);
      // act
      loginBloc.add(LoginSubmitted());
      // assert
      final expectedOrder = [
        const LoginState(
          isUsernameValid: true,
          isPasswordValid: false,
          loginStatus: LoginStatus.failure,
          errorMessage: 'Please, enter valid credentials',
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verifyZeroInteractions(mockLoginUser);
      verifyZeroInteractions(mockAuthenticationRepository);
    });

    test(
        'should return [LoginState] with LoginStatus.failure, '
        'isUsernameValid: false and isPasswordValid: false if '
        'password and username are invalid', () async {
      // arrange
      when(() => mockFormValidator.isUsernameValid(any())).thenReturn(false);
      when(() => mockFormValidator.isPasswordValid(any())).thenReturn(false);
      // act
      loginBloc.add(LoginSubmitted());
      // assert
      final expectedOrder = [
        const LoginState(
          isUsernameValid: false,
          isPasswordValid: false,
          loginStatus: LoginStatus.failure,
          errorMessage: 'Please, enter valid credentials',
        ),
      ];
      await expectLater(loginBloc.stream, emitsInOrder(expectedOrder));
      verifyZeroInteractions(mockLoginUser);
      verifyZeroInteractions(mockAuthenticationRepository);
    });
  });
}
