import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/login.dart';
import '../repositories/login_repository.dart';

class LoginUser implements UseCase<Login, LoginParams> {
  final LoginRepository loginRepository;

  LoginUser(this.loginRepository);

  @override
  Future<Either<Failure, Login>> call(LoginParams params) async {
    final loginData = await loginRepository.login(params);
    return loginData;
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  static Map<String, dynamic> toJson(LoginParams params) =>
      {'email': params.email, 'password': params.password};

  @override
  List<Object?> get props => [email, password];
}
