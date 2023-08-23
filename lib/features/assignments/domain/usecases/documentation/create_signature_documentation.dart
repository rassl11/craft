import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/documentation.dart';
import '../../repositories/documentation_repository.dart';

class CreateSignatureDocumentation extends UseCase<SingleDocumentationHolder,
    CreateSignatureDocumentationParams> {
  final DocumentationRepository _repository;

  CreateSignatureDocumentation(this._repository);

  @override
  Future<Either<Failure, SingleDocumentationHolder>> call(
    CreateSignatureDocumentationParams params,
  ) async {
    return _repository.postSignature(params: params);
  }
}

class CreateSignatureDocumentationParams extends Equatable {
  final int assignmentId;
  final String title;
  final Uint8List uploadFile1;
  final Uint8List uploadFile2;

  const CreateSignatureDocumentationParams({
    required this.assignmentId,
    required this.title,
    required this.uploadFile1,
    required this.uploadFile2,
  });

  @override
  List<Object?> get props => [
        assignmentId,
        title,
        uploadFile1,
        uploadFile2,
      ];
}
