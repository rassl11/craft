import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/file_repository.dart';

class GetFile extends UseCase<File, FileParams> {
  final FileRepository _repository;

  GetFile(this._repository);

  @override
  Future<Either<Failure, File>> call(FileParams params) async {
    return _repository.downloadFile(
      url: params.url,
      fileName: params.fileName,
      onProgressChanged: (progress) {
        if (params.onProgressChanged != null) {
          params.onProgressChanged!(progress);
        }
      },
    );
  }
}

class FileParams extends Equatable {
  final String url;
  final String fileName;
  final Function(int)? onProgressChanged;

  const FileParams({
    required this.url,
    required this.fileName,
    this.onProgressChanged,
  });

  @override
  List<Object?> get props => [url, fileName, onProgressChanged];
}
