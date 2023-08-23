import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/assignments_utils.dart';
import '../../domain/entities/assignments_data_holder.dart';
import '../../domain/entities/customer_data_holder.dart';
import '../../domain/repositories/assignments_repository.dart';
import '../sources/assignments_remote_data_source.dart';

class AssignmentsRepositoryImpl extends AssignmentsRepository {
  final AssignmentsRemoteDataSource _remoteDataSource;

  AssignmentsRepositoryImpl({
    required AssignmentsRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        super(networkInfo);

  @override
  Future<Either<Failure, AssignmentsListHolder>> fetchAssignments({
    String? withRelation,
  }) async {
    return checkNetworkAndDoRequest<AssignmentsListHolder>(
          () => _remoteDataSource.getAssignments(withRelation: withRelation),
    );
  }

  @override
  Future<Either<Failure, CustomerDataHolder>> getCustomerInfoBy({
    required int addressId,
  }) async {
    return checkNetworkAndDoRequest<CustomerDataHolder>(() {
      return _remoteDataSource.getCustomerBy(addressId: addressId);
    });
  }

  @override
  Future<Either<Failure, SingleAssignmentHolder>> fetchDetailedAssignment({
    required int assignmentId,
  }) async {
    return checkNetworkAndDoRequest<SingleAssignmentHolder>(() {
      return _remoteDataSource.getDetailedAssignment(
        assignmentId: assignmentId,
      );
    });
  }

  @override
  Future<Either<Failure, SingleAssignmentHolder>> putAssignmentState({
    required int assignmentId,
    required InAppAssignmentState stateToBeSet,
  }) {
    return checkNetworkAndDoRequest<SingleAssignmentHolder>(() {
      return _remoteDataSource.putAssignmentState(
        assignmentId: assignmentId,
        stateToBeSet: stateToBeSet,
      );
    });
  }
}
