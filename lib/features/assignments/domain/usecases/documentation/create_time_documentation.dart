import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/documentation.dart';
import '../../repositories/documentation_repository.dart';

class CreateTimeDocumentation
    extends UseCase<SingleDocumentationHolder, CreateTimeDocumentationParams> {
  final DocumentationRepository _repository;

  CreateTimeDocumentation(this._repository);

  @override
  Future<Either<Failure, SingleDocumentationHolder>> call(
    CreateTimeDocumentationParams params,
  ) async {
    return _repository.postTime(params: params);
  }
}

class CreateTimeDocumentationParams extends Equatable {
  final int assignmentId;
  final int workingTime;
  final int breakTime;
  final int drivingTime;
  final String? description;
  final String title;

  const CreateTimeDocumentationParams({
    required this.assignmentId,
    required this.workingTime,
    required this.breakTime,
    required this.drivingTime,
    required this.description,
    required this.title,
  });

  @override
  List<Object?> get props => [
        assignmentId,
        workingTime,
        breakTime,
        drivingTime,
        description,
        title,
      ];
}
