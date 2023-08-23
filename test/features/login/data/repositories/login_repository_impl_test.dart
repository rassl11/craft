import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/exceptions.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/network/network_info.dart';
import 'package:share/features/login/data/models/forgot_password_model.dart';
import 'package:share/features/login/data/models/login_model.dart';
import 'package:share/features/login/data/repositories/login_repository_impl.dart';
import 'package:share/features/login/data/sources/login_remote_data_source.dart';
import 'package:share/features/login/domain/repositories/login_repository.dart';
import 'package:share/features/login/domain/usecases/login_user.dart';

class MockRemoteLoginDataSource extends Mock implements RemoteLoginDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late LoginRepository repository;
  late MockRemoteLoginDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(
        email: 'mail',
        password: 'password',
      ),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteLoginDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = LoginRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('login', () {
    const tLoginParams = LoginParams(email: 'mail', password: 'password');
    const tLoginModel = LoginModel(accessToken: 'token', tokenType: 'type');

    runTestsOnline(() {
      test(
        '''should check if the device is online and return remote data when the call to remote data source is successful''',
        () async {
          // arrange
          when(() => mockRemoteDataSource.login(any()))
              .thenAnswer((_) async => tLoginModel);
          // act
          final result = await repository.login(tLoginParams);
          // assert
          verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.login(tLoginParams));
          expect(result, equals(const Right(tLoginModel)));
        },
      );

      test(
        '''should return ServerFailure with errorCode and message when ServerException was thrown by remote data source''',
        () async {
          const tErrorCode = 500;
          // arrange
          when(() => mockRemoteDataSource.login(any()))
              .thenThrow(ServerException(code: tErrorCode));
          // act
          final result = await repository.login(tLoginParams);
          // assert
          verify(() => mockRemoteDataSource.login(tLoginParams));
          expect(result, equals(const Left(ServerFailure(code: tErrorCode))));
        },
      );

      test(
        'should return AuthorizationFailure when AuthorizationException was '
        'thrown by remote data source',
        () async {
          // arrange
          when(() => mockRemoteDataSource.login(any()))
              .thenThrow(AuthorizationException());
          // act
          final result = await repository.login(tLoginParams);
          // assert
          verify(() => mockRemoteDataSource.login(tLoginParams));
          expect(result, equals(Left(AuthorizationFailure())));
        },
      );

      test(
        'should return UnexpectedFailure with a message when unexpected '
        'exception was thrown by remote data source',
        () async {
          const tUnexpectedError = 'unexpectedError';
          // arrange
          when(() => mockRemoteDataSource.login(any()))
              .thenThrow(Exception(tUnexpectedError));
          // act
          final result = await repository.login(tLoginParams);
          // assert
          verify(() => mockRemoteDataSource.login(tLoginParams));
          expect(
            result,
            equals(
              const Left(
                UnexpectedFailure(
                  message: 'Exception: $tUnexpectedError',
                ),
              ),
            ),
          );
        },
      );
    });

    runTestsOffline(() {
      test(
        '''should return InternetConnectionFailure''',
        () async {
          // act
          final result = await repository.login(tLoginParams);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(InternetConnectionFailure())));
        },
      );
    });
  });

  group('forgot password', () {
    const tMail = 'mail';
    const tForgotPasswordModel = ForgotPasswordModel(success: 'success');

    runTestsOnline(() {
      test(
        '''should check if the device is online and return remote data when the call to remote data source is successful''',
        () async {
          // arrange
          when(() => mockRemoteDataSource.forgotPassword(any()))
              .thenAnswer((_) async => tForgotPasswordModel);
          // act
          final result = await repository.forgotPassword(tMail);
          // assert
          verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.forgotPassword(tMail));
          expect(result, equals(const Right(tForgotPasswordModel)));
        },
      );

      test(
        '''should return ServerFailure with errorCode and message when ServerException was thrown by remote data source''',
        () async {
          const tErrorCode = 500;
          // arrange
          when(() => mockRemoteDataSource.forgotPassword(any()))
              .thenThrow(ServerException(code: tErrorCode));
          // act
          final result = await repository.forgotPassword(tMail);
          // assert
          verify(() => mockRemoteDataSource.forgotPassword(tMail));
          expect(result, equals(const Left(ServerFailure(code: tErrorCode))));
        },
      );

      test(
        '''should return AuthorizationFailure when AuthorizationException was thrown by remote data source''',
        () async {
          // arrange
          when(() => mockRemoteDataSource.forgotPassword(any()))
              .thenThrow(AuthorizationException());
          // act
          final result = await repository.forgotPassword(tMail);
          // assert
          verify(() => mockRemoteDataSource.forgotPassword(tMail));
          expect(result, equals(Left(AuthorizationFailure())));
        },
      );

      test(
        '''should return UnexpectedFailure with a message when unexpected exception was thrown by remote data source''',
        () async {
          const tUnexpectedError = 'unexpectedError';
          // arrange
          when(() => mockRemoteDataSource.forgotPassword(any()))
              .thenThrow(Exception(tUnexpectedError));
          // act
          final result = await repository.forgotPassword(tMail);
          // assert
          verify(() => mockRemoteDataSource.forgotPassword(tMail));
          expect(
            result,
            equals(
              const Left(
                UnexpectedFailure(
                  message: 'Exception: $tUnexpectedError',
                ),
              ),
            ),
          );
        },
      );

      test(
        '''should return UserValidationFailure when ValidationException was thrown by remote data source''',
        () async {
          // arrange
          when(() => mockRemoteDataSource.forgotPassword(any()))
              .thenThrow(ValidationException());
          // act
          final result = await repository.forgotPassword(tMail);
          // assert
          verify(() => mockRemoteDataSource.forgotPassword(tMail));
          expect(result, equals(Left(UserValidationFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        '''should return InternetConnectionFailure''',
        () async {
          // act
          final result = await repository.forgotPassword(tMail);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(InternetConnectionFailure())));
        },
      );
    });
  });
}
