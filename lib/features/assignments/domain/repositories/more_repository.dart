import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../assignments/domain/entities/logout.dart';

abstract class MoreRepository extends BaseRepository {
  MoreRepository(super.networkInfo);

  Future<Either<Failure, Logout>> logout();
}
