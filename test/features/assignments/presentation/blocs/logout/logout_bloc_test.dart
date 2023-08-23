import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/blocs/status.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/core/usecases/usecase.dart';
import 'package:share/features/assignments/domain/entities/logout.dart';
import 'package:share/features/assignments/domain/usecases/logout_user.dart';
import 'package:share/features/assignments/presentation/blocs/logout/logout_bloc.dart';

class MockLogoutUser extends Mock implements LogoutUser {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late MockLogoutUser mockLogoutUser;
  late MockAuthenticationRepository authenticationRepository;
  late LogoutBloc logoutBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockLogoutUser = MockLogoutUser();
    authenticationRepository = MockAuthenticationRepository();
    logoutBloc = LogoutBloc(
      logoutUser: mockLogoutUser,
      authenticationRepository: authenticationRepository,
    );
  });

  test('initial logoutStatus should be LogoutStatus.initial', () {
    // assert
    expect(
      logoutBloc.state.logoutStatus,
      equals(Status.initial),
    );
  });

  group('LogoutUser', () {
    const tLogout = Logout(success: 'success');

    test(
        'should emit [LogoutState] with the LogoutStatus.success after'
        ' LogoutStatus.loading if Logout object was returned', () async {
      // arrange
      when(() => mockLogoutUser(any()))
          .thenAnswer((_) async => const Right(tLogout));
      when(() => authenticationRepository.logOut())
          .thenAnswer((_) async => true);
      // act
      logoutBloc.add(LogoutSubmitted());
      // assert
      final expectedOrder = [
        const LogoutState(logoutStatus: Status.loading),
        const LogoutState(logoutStatus: Status.loaded),
      ];
      await expectLater(logoutBloc.stream, emitsInOrder(expectedOrder));
      verify(() => mockLogoutUser(NoParams()));
      verify(() => authenticationRepository.logOut());
      verifyNoMoreInteractions(mockLogoutUser);
    });

    test(
        'should emit [LogoutState] with the LogoutStatus.failure after'
        ' LogoutStatus.loading if Failure object was returned', () async {
      // arrange
      when(() => mockLogoutUser(any()))
          .thenAnswer((_) async => Left(InternetConnectionFailure()));
      when(() => authenticationRepository.logOut())
          .thenAnswer((_) async => true);
      // act
      logoutBloc.add(LogoutSubmitted());
      // assert
      final expectedOrder = [
        const LogoutState(logoutStatus: Status.loading),
        const LogoutState(logoutStatus: Status.error),
      ];
      await expectLater(logoutBloc.stream, emitsInOrder(expectedOrder));
      verify(() => mockLogoutUser(NoParams()));
      verify(() => authenticationRepository.logOut());
      verifyNoMoreInteractions(mockLogoutUser);
    });
  });
}
