import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../repositories/documentation_repository.dart';

class DeleteDocumentation
    extends UseCase<dynamic, DeleteDocumentationParams> {
  final DocumentationRepository _repository;

  DeleteDocumentation(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(
      DeleteDocumentationParams params,
  ) async {
    return _repository.delete(params: params);
  }
}

class DeleteDocumentationParams extends Equatable {
  final int id;

  const DeleteDocumentationParams({
    required this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];
}
