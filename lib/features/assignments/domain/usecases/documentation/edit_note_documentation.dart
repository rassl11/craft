import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/documentation.dart';
import '../../repositories/documentation_repository.dart';

class EditNoteDocumentation
    extends UseCase<SingleDocumentationHolder, EditNoteDocumentationParams> {
  final DocumentationRepository _repository;

  EditNoteDocumentation(this._repository);

  @override
  Future<Either<Failure, SingleDocumentationHolder>> call(
    EditNoteDocumentationParams params,
  ) async {
    return _repository.editNote(params: params);
  }
}

class EditNoteDocumentationParams extends Equatable {
  final int assignmentId;
  final int documentationId;
  final String? description;
  final String title;

  const EditNoteDocumentationParams({
    required this.assignmentId,
    required this.documentationId,
    required this.description,
    required this.title,
  });

  @override
  List<Object?> get props => [
        assignmentId,
        documentationId,
        description,
        title,
      ];
}
