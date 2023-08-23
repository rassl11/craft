import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/exceptions.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/network/network_info.dart';
import 'package:share/features/assignments/data/models/logout_model.dart';
import 'package:share/features/assignments/data/repositories/more_repository_impl.dart';
import 'package:share/features/assignments/data/sources/more_remote_data_source.dart';
import 'package:share/features/assignments/domain/repositories/more_repository.dart';

class MockRemoteMoreDataSource extends Mock implements RemoteMoreDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MoreRepository repository;
  late MockRemoteMoreDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteMoreDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MoreRepositoryImpl(
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

  group('logout', () {
    const tLogoutModel = LogoutModel(success: 'success');

    runTestsOnline(() {
      test(
        '''should check if the device is online and return remote data when the call to remote data source is successful''',
        () async {
          // arrange
          when(() => mockRemoteDataSource.logout())
              .thenAnswer((_) async => tLogoutModel);
          // act
          final result = await repository.logout();
          // assert
          verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.logout());
          expect(result, equals(const Right(tLogoutModel)));
        },
      );

      test(
        '''
should return ServerFailure with errorCode and message when 
        ServerException was thrown by remote data source
        ''',
        () async {
          const tErrorCode = 500;
          // arrange
          when(() => mockRemoteDataSource.logout())
              .thenThrow(ServerException(code: tErrorCode));
          // act
          final result = await repository.logout();
          // assert
          verify(() => mockRemoteDataSource.logout());
          expect(result, equals(const Left(ServerFailure(code: tErrorCode))));
        },
      );

      test(
        '''
should return AuthorizationFailure when AuthorizationException was 
        thrown by remote data source
        ''',
        () async {
          // arrange
          when(() => mockRemoteDataSource.logout())
              .thenThrow(AuthorizationException());
          // act
          final result = await repository.logout();
          // assert
          verify(() => mockRemoteDataSource.logout());
          expect(result, equals(Left(AuthorizationFailure())));
        },
      );

      test(
        '''should return UnexpectedFailure with a message when unexpected exception was thrown by remote data source''',
        () async {
          const tUnexpectedError = 'unexpectedError';
          // arrange
          when(() => mockRemoteDataSource.logout())
              .thenThrow(Exception(tUnexpectedError));
          // act
          final result = await repository.logout();
          // assert
          verify(() => mockRemoteDataSource.logout());
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
          final result = await repository.logout();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(InternetConnectionFailure())));
        },
      );
    });
  });
}
