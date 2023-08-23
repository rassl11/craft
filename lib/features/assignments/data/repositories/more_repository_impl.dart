import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../assignments/domain/entities/logout.dart';
import '../../domain/repositories/more_repository.dart';
import '../sources/more_remote_data_source.dart';

class MoreRepositoryImpl extends MoreRepository {
  final RemoteMoreDataSource _remoteDataSource;

  MoreRepositoryImpl({
    required RemoteMoreDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        super(networkInfo);

  @override
  Future<Either<Failure, Logout>> logout() async {
    return checkNetworkAndDoRequest<Logout>(_remoteDataSource.logout);
  }
}
