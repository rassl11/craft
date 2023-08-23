import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/forgot_password.dart';
import '../../domain/entities/login.dart';
import '../../domain/repositories/login_repository.dart';
import '../../domain/usecases/login_user.dart';
import '../sources/login_remote_data_source.dart';

class LoginRepositoryImpl extends LoginRepository {
  final RemoteLoginDataSource remoteDataSource;

  LoginRepositoryImpl({
    required this.remoteDataSource,
    required NetworkInfo networkInfo,
  }) : super(networkInfo);

  @override
  Future<Either<Failure, Login>> login(LoginParams params) async {
    return checkNetworkAndDoRequest<Login>(() {
      return remoteDataSource.login(params);
    });
  }

  @override
  Future<Either<Failure, ForgotPassword>> forgotPassword(String email) async {
    return checkNetworkAndDoRequest<ForgotPassword>(() {
      return remoteDataSource.forgotPassword(email);
    });
  }
}
