import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/blocs/authentication/authentication_bloc.dart';
import 'package:share/core/repositories/authentication_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    when(
      () => mockAuthenticationRepository.status,
    ).thenAnswer((_) => const Stream.empty());
  });

  test('initial state should be AuthenticationState.unknown', () {
    final authenticationBloc = AuthenticationBloc(
      authenticationRepository: mockAuthenticationRepository,
    );
    // assert
    expect(
      authenticationBloc.state,
      equals(const AuthenticationState.unknown()),
    );
  });

  group('AuthenticationStatusChanged', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unauthenticated] when status is unauthenticated',
      setUp: () {
        when(() => mockAuthenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unauthenticated),
        );
      },
      build: () => AuthenticationBloc(
        authenticationRepository: mockAuthenticationRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [authenticated] when status is authenticated',
      setUp: () {
        when(() => mockAuthenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.authenticated),
        );
      },
      build: () => AuthenticationBloc(
        authenticationRepository: mockAuthenticationRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.authenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [unknown] when status is unknown',
      setUp: () {
        when(() => mockAuthenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unknown),
        );
      },
      build: () => AuthenticationBloc(
        authenticationRepository: mockAuthenticationRepository,
      ),
      expect: () => const <AuthenticationState>[
        AuthenticationState.unknown(),
      ],
    );
  });
}
