import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/assignments_utils.dart';
import '../../entities/assignments_data_holder.dart';
import '../../repositories/assignments_repository.dart';

class ChangeAssignmentState
    extends UseCase<SingleAssignmentHolder, ChangeAssignmentStateParams> {
  final AssignmentsRepository _repository;

  ChangeAssignmentState(this._repository);

  @override
  Future<Either<Failure, SingleAssignmentHolder>> call(
    ChangeAssignmentStateParams params,
  ) async {
    return _repository.putAssignmentState(
      assignmentId: params.assignmentId,
      stateToBeSet: params.stateToBeSet,
    );
  }
}

class ChangeAssignmentStateParams extends Equatable {
  final int assignmentId;
  final InAppAssignmentState stateToBeSet;

  const ChangeAssignmentStateParams({
    required this.assignmentId,
    required this.stateToBeSet,
  });

  @override
  List<Object?> get props => [assignmentId];
}
