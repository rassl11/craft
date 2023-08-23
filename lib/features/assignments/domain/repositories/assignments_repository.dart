import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/utils/assignments_utils.dart';
import '../entities/assignments_data_holder.dart';
import '../entities/customer_data_holder.dart';

abstract class AssignmentsRepository extends BaseRepository {
  AssignmentsRepository(super.networkInfo);

  Future<Either<Failure, AssignmentsListHolder>> fetchAssignments({
    String? withRelation,
  });

  Future<Either<Failure, CustomerDataHolder>> getCustomerInfoBy({
    required int addressId,
  });

  Future<Either<Failure, SingleAssignmentHolder>> fetchDetailedAssignment({
    required int assignmentId,
  });

  Future<Either<Failure, SingleAssignmentHolder>> putAssignmentState({
    required int assignmentId,
    required InAppAssignmentState stateToBeSet,
  });
}
