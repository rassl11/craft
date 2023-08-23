import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/shared_prefs.dart';
import 'package:share/features/login/domain/entities/login.dart';
import 'package:share/features/login/domain/repositories/login_repository.dart';
import 'package:share/features/login/domain/usecases/login_user.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

class MockPrefs extends Mock implements SharedPrefs {}

void main() {
  late LoginUser useCase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    useCase = LoginUser(mockLoginRepository);
  });

  const String tEmail = 'email';
  const String tPassword = 'password';
  const Login tLogin =
      Login(accessToken: 'testAccessToken', tokenType: 'testTokenType');

  test(
    'should try to get Login data from the repository and save token to shared '
    'prefs if Login data was successfully returned',
    () async {
      // arrange
      when(() => mockLoginRepository.login(
            const LoginParams(
              email: tEmail,
              password: tPassword,
            ),
          )).thenAnswer((_) async => const Right(tLogin));
      // act
      final result = await useCase(
        const LoginParams(
          email: tEmail,
          password: tPassword,
        ),
      );
      // assert
      expect(result, const Right(tLogin));
      verify(
        () => mockLoginRepository.login(
          const LoginParams(
            email: tEmail,
            password: tPassword,
          ),
        ),
      );
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );

  test(
    'should try to get Login data from the repository and skip token saving if'
    ' Login data wasn`t successfully returned',
    () async {
      // arrange
      when(() => mockLoginRepository.login(
            const LoginParams(
              email: tEmail,
              password: tPassword,
            ),
          )).thenAnswer((_) async => const Left(ServerFailure(code: 500)));
      // act
      final result = await useCase(
        const LoginParams(
          email: tEmail,
          password: tPassword,
        ),
      );
      // assert
      expect(result, const Left(ServerFailure(code: 500)));
      verify(
        () => mockLoginRepository.login(
          const LoginParams(
            email: tEmail,
            password: tPassword,
          ),
        ),
      );
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
