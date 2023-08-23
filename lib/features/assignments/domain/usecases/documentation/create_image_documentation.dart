import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/documentation.dart';
import '../../repositories/documentation_repository.dart';

class CreateImageDocumentation
    extends UseCase<SingleDocumentationHolder, CreateImageDocumentationParams> {
  final DocumentationRepository _repository;

  CreateImageDocumentation(this._repository);

  @override
  Future<Either<Failure, SingleDocumentationHolder>> call(
      CreateImageDocumentationParams params,
      ) async {
    return _repository.postImage(params: params);
  }
}

class CreateImageDocumentationParams extends Equatable {
  final int assignmentId;
  final String title;
  final Uint8List image;

  const CreateImageDocumentationParams({
    required this.assignmentId,
    required this.image,
    required this.title,
  });

  @override
  List<Object?> get props => [
    assignmentId,
    image,
    title,
  ];
}
