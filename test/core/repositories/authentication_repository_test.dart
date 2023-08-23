import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/core/shared_prefs.dart';

class MockSharedPrefs extends Mock implements SharedPrefs {}

void main() {
  late MockSharedPrefs mockSharedPrefs;
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    mockSharedPrefs = MockSharedPrefs();
    authenticationRepository = AuthenticationRepository(mockSharedPrefs);
  });

  group('get status', () {
    test('returns unknown when token is empty', () {
      // arrange
      when(() => mockSharedPrefs.token).thenReturn('');
      // assert
      expect(
        authenticationRepository.status,
        emits(AuthenticationStatus.unknown),
      );
    });

    test('returns authenticated when token is not empty', () {
      // arrange
      when(() => mockSharedPrefs.token).thenReturn('token');
      // assert
      expect(
        authenticationRepository.status,
        emits(AuthenticationStatus.authenticated),
      );
    });
  });

  group('logIn', () {
    test('set token and add AuthenticationStatus.authenticated', () {
      // arrange
      when(() => mockSharedPrefs.token).thenReturn('');
      when(() => mockSharedPrefs.setToken(any()))
          .thenAnswer((_) async => Future.value(true));
      // act
      authenticationRepository.logIn(token: 'token');
      // assert
      expect(
        authenticationRepository.status,
        emitsInOrder([
          AuthenticationStatus.unknown,
          AuthenticationStatus.authenticated,
        ]),
      );
    });
  });

  group('unauthenticate', () {
    test(
        'should call sharedPrefs.logout() and '
        'add AuthenticationStatus.unauthenticated', () {
      // arrange
      when(() => mockSharedPrefs.token).thenReturn('');
      when(() => mockSharedPrefs.logout())
          .thenAnswer((_) async => Future.value(true));
      // act
      authenticationRepository.unauthenticate();
      // assert
      expect(
        authenticationRepository.status,
        emitsInOrder([
          AuthenticationStatus.unknown,
          AuthenticationStatus.unauthenticated,
        ]),
      );
    });
  });

  group('logOut', () {
    test(
        'should call sharedPrefs.logout() and '
        'add AuthenticationStatus.unknown', () {
      // arrange
      when(() => mockSharedPrefs.token).thenReturn('');
      when(() => mockSharedPrefs.logout())
          .thenAnswer((_) async => Future.value(true));
      // act
      authenticationRepository.logOut();
      // assert
      expect(
        authenticationRepository.status,
        emitsInOrder([
          AuthenticationStatus.unknown,
          AuthenticationStatus.unknown,
        ]),
      );
    });
  });
}
