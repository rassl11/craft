import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/documentation.dart';
import '../../repositories/documentation_repository.dart';

class CreateNoteDocumentation
    extends UseCase<SingleDocumentationHolder, CreateNoteDocumentationParams> {
  final DocumentationRepository _repository;

  CreateNoteDocumentation(this._repository);

  @override
  Future<Either<Failure, SingleDocumentationHolder>> call(
      CreateNoteDocumentationParams params,
  ) async {
    return _repository.postNote(params: params);
  }
}

class CreateNoteDocumentationParams extends Equatable {
  final int assignmentId;
  final String description;
  final String title;

  const CreateNoteDocumentationParams({
    required this.assignmentId,
    required this.description,
    required this.title,
  });

  @override
  List<Object?> get props => [
        assignmentId,
        description,
        title,
      ];
}
