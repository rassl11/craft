import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';
import '../network/network_info.dart';

class BaseRepository {
  final NetworkInfo _networkInfo;

  BaseRepository(this._networkInfo);

  Future<Either<Failure, T>> checkNetworkAndDoRequest<T>(
    Future<T> Function() request,
  ) async {
    if (await _networkInfo.isConnected) {
      return _doRequest(request);
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  Future<Either<Failure, T>> _doRequest<T>(Future<T> Function() request) async {
    try {
      final result = await request();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, error: e.error));
    } on AuthorizationException {
      return Left(AuthorizationFailure());
    } on ValidationException {
      return Left(UserValidationFailure());
    } catch (e) {
      log('Request Result: $e', stackTrace: e is Error ? e.stackTrace : null);
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
