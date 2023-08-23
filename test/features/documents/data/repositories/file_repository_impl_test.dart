import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/network/network_info.dart';
import 'package:share/features/documents/data/repositories/file_repository_impl.dart';
import 'package:share/features/documents/data/sources/file_local_data_source.dart';
import 'package:share/features/documents/data/sources/file_remote_data_source.dart';
import 'package:share/features/documents/domain/repositories/file_repository.dart';

class MockFileRemoteDataSource extends Mock implements FileRemoteDataSource {}

class MockFileLocalDataSource extends Mock implements FileLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late FileRepository repository;
  late MockFileRemoteDataSource mockRemoteDataSource;
  late MockFileLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockFileRemoteDataSource();
    mockLocalDataSource = MockFileLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = FileRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  group('downloadFile', () {
    test('should return a Right when requested file was found in cache',
        () async {
      final file = File('');
      const fileName = 'goodFile.txt';

      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getCachedFile(any()))
          .thenAnswer((_) async => file);
      // act
      final result = await repository.downloadFile(
          url: '', fileName: fileName, onProgressChanged: (progress) {});
      // assert
      expect(result, equals(Right(file)));
      verify(() => mockLocalDataSource.getCachedFile(fileName));
    });

    test(
        'should return a Right when requested file was not found in cache, '
        'but was successfully downloaded and cached', () async {
      final file = File('');
      const fileName = 'goodFile.txt';
      final downloadedBytes = Uint8List(0);
      const url = 'fileUrl';
      void onProgressChanged(progress) {}

      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getCachedFile(any()))
          .thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.downloadFile(any(), any()))
          .thenAnswer((_) async {
        return downloadedBytes;
      });
      when(() => mockLocalDataSource.writeFileToTempDir(any(), any()))
          .thenAnswer((_) async => file);
      // act
      final result = await repository.downloadFile(
          url: url, fileName: fileName, onProgressChanged: onProgressChanged);
      // assert
      expect(result, equals(Right(file)));
      verify(() => mockLocalDataSource.getCachedFile(fileName));
      verify(
        () => mockLocalDataSource.writeFileToTempDir(
          fileName,
          downloadedBytes,
        ),
      );
      verify(
        () => mockRemoteDataSource.downloadFile(
          url,
          onProgressChanged,
        ),
      );
    });

    test(
        'should return a Left when requested file was not found in cache, '
        ' was successfully downloaded, but failed to cache', () async {
      const fileName = 'goodFile.txt';
      final downloadedBytes = Uint8List(0);
      const url = 'fileUrl';
      void onProgressChanged(progress) {}

      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getCachedFile(any()))
          .thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.downloadFile(any(), any()))
          .thenAnswer((_) async {
        return downloadedBytes;
      });
      when(() => mockLocalDataSource.writeFileToTempDir(any(), any()))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.downloadFile(
          url: url, fileName: fileName, onProgressChanged: onProgressChanged);
      // assert
      expect(
          result,
          equals(const Left(UnexpectedFailure(
            message: 'Failed to cache a file',
          ))));
      verify(() => mockLocalDataSource.getCachedFile(fileName));
      verify(
        () => mockLocalDataSource.writeFileToTempDir(
          fileName,
          downloadedBytes,
        ),
      );
      verify(
        () => mockRemoteDataSource.downloadFile(
          url,
          onProgressChanged,
        ),
      );
    });
  });
}
