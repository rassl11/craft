import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/assignments_data_holder.dart';
import '../../repositories/assignments_repository.dart';

class FetchDetailedAssignment
    extends UseCase<SingleAssignmentHolder, DetailedAssignmentParams> {
  final AssignmentsRepository _repository;

  FetchDetailedAssignment(this._repository);

  @override
  Future<Either<Failure, SingleAssignmentHolder>> call(
    DetailedAssignmentParams params,
  ) async {
    return _repository.fetchDetailedAssignment(
      assignmentId: params.assignmentId,
    );
  }
}

class DetailedAssignmentParams extends Equatable {
  final int assignmentId;

  const DetailedAssignmentParams(this.assignmentId);

  @override
  List<Object?> get props => [assignmentId];
}
