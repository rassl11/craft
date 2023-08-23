import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../entities/forgot_password.dart';
import '../entities/login.dart';
import '../usecases/login_user.dart';

abstract class LoginRepository extends BaseRepository {
  LoginRepository(super.networkInfo);

  Future<Either<Failure, Login>> login(LoginParams params);

  Future<Either<Failure, ForgotPassword>> forgotPassword(String email);
}
