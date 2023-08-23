import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';

abstract class FileRepository extends BaseRepository {
  FileRepository(super.networkInfo);

  Future<Either<Failure, File>> downloadFile({
    required String url,
    required String fileName,
    required Function(int) onProgressChanged,
  });
}
