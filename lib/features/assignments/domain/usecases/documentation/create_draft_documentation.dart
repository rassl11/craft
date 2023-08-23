import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/documentation.dart';
import '../../repositories/documentation_repository.dart';

class CreateDraftDocumentation
    extends UseCase<SingleDocumentationHolder, CreateDraftDocumentationParams> {
  final DocumentationRepository _repository;

  CreateDraftDocumentation(this._repository);

  @override
  Future<Either<Failure, SingleDocumentationHolder>> call(
      CreateDraftDocumentationParams params,
      ) async {
    return _repository.postDraft(params: params);
  }
}

class CreateDraftDocumentationParams extends Equatable {
  final int assignmentId;
  final String title;
  final Uint8List draft;

  const CreateDraftDocumentationParams({
    required this.assignmentId,
    required this.title,
    required this.draft,
  });

  @override
  List<Object?> get props => [
    assignmentId,
    title,
    draft,
  ];
}
