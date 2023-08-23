import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/forgot_password.dart';
import '../repositories/login_repository.dart';

class PostForgotPassword
    implements UseCase<ForgotPassword, ForgotPasswordParams> {
  final LoginRepository loginRepository;

  PostForgotPassword(this.loginRepository);

  @override
  Future<Either<Failure, ForgotPassword>> call(
      ForgotPasswordParams params) async {
    return loginRepository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams(this.email);

  @override
  List<Object?> get props => [
        email,
      ];
}
