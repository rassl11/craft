import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/logout.dart';
import '../repositories/more_repository.dart';

class LogoutUser implements UseCase<Logout, NoParams> {
  final MoreRepository _moreRepository;

  LogoutUser(this._moreRepository);

  @override
  Future<Either<Failure, Logout>> call(NoParams params) async {
    final logout = await _moreRepository.logout();
    return logout;
  }
}