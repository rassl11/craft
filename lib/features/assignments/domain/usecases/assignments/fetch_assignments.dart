import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../presentation/widgets/craftbox_slider.dart';
import '../../entities/assignments_data_holder.dart';
import '../../repositories/assignments_repository.dart';
import 'assignments_refiner.dart';

class FetchAssignments
    implements UseCase<AssignmentsListHolder, AssignmentsParams> {
  final AssignmentsRepository _repository;
  final AssignmentsRefiner _assignmentsRefiner;

  @visibleForTesting
  List<Assignment> assignments = [];

  FetchAssignments(this._repository, this._assignmentsRefiner);

  @override
  Future<Either<Failure, AssignmentsListHolder>> call(
      AssignmentsParams params) async {
    if (assignments.isEmpty || params.isDataUpdateRequired) {
      final assignmentsOrFailure =
          await _repository.fetchAssignments(withRelation: params.withRelation);
      if (assignmentsOrFailure.isLeft()) {
        return assignmentsOrFailure;
      }
      final assignmentsDataHolder = assignmentsOrFailure.getOrElse(
        () => AssignmentsListHolder(data: List.empty()),
      );

      assignments = assignmentsDataHolder.data;
    }

    return Right(AssignmentsListHolder(data: _refineAssignments(params)));
  }

  List<Assignment> _refineAssignments(
    AssignmentsParams params,
  ) {
    final filteredAssignmentsByTime =
        _assignmentsRefiner.getFilteredAssignments(
      unfilteredAssignments: assignments,
      activeSegment: params.activeSegment,
      requestedStates: params.requestedStates,
    )..sort(_assignmentsRefiner.compareAppointments);

    return filteredAssignmentsByTime;
  }

  void clearAssignments() {
    assignments = [];
  }
}

class AssignmentsParams extends Equatable {
  final bool isDataUpdateRequired;
  final String withRelation;
  final ActiveSegment activeSegment;
  final List<OriginalAssignmentState> requestedStates;

  const AssignmentsParams({
    required this.isDataUpdateRequired,
    required this.withRelation,
    required this.activeSegment,
    required this.requestedStates,
  });

  @override
  List<Object> get props => [
        isDataUpdateRequired,
        withRelation,
        activeSegment,
        requestedStates,
      ];
}
