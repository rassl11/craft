import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/file_repository.dart';
import '../sources/file_local_data_source.dart';
import '../sources/file_remote_data_source.dart';

class FileRepositoryImpl extends FileRepository {
  final FileRemoteDataSource remoteDataSource;
  final FileLocalDataSource localDataSource;

  FileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required NetworkInfo networkInfo,
  }) : super(networkInfo);

  @override
  Future<Either<Failure, File>> downloadFile({
    required String url,
    required String fileName,
    required Function(int) onProgressChanged,
  }) async {
    final File? cachedFile = await _tryToGetFileFromCache(fileName);
    if (cachedFile != null) {
      return Right(cachedFile);
    }

    final bytesOrFailure = await checkNetworkAndDoRequest(() {
      return remoteDataSource.downloadFile(url, onProgressChanged);
    });

    if (bytesOrFailure.isLeft()) {
      return Left(
        bytesOrFailure.fold(
          (failure) => failure,
          (bytes) => const UnexpectedFailure(
              message: 'Unexpected failure during file downloading'),
        ),
      );
    }

    return _cacheFileAndReturnEither(bytesOrFailure, fileName);
  }

  Future<File?> _tryToGetFileFromCache(String fileName) async {
    try {
      return await localDataSource.getCachedFile(fileName);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Either<Failure, File>> _cacheFileAndReturnEither(
    Either<Failure, Uint8List> bytesOrFailure,
    String fileName,
  ) async {
    final bytes = bytesOrFailure.getOrElse(() => Uint8List(0));
    final downloadedFile = await localDataSource.writeFileToTempDir(
      fileName,
      bytes,
    );
    if (downloadedFile == null) {
      return const Left(
        UnexpectedFailure(
          message: 'Failed to cache a file',
        ),
      );
    }

    return Right(downloadedFile);
  }
}
