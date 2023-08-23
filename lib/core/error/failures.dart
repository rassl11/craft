import 'package:equatable/equatable.dart';

import '../entities/craftbox_error.dart';

abstract class Failure extends Equatable {
  final int? code;
  final CraftboxError? error;
  final String? message;

  const Failure({
    this.code,
    this.error,
    this.message,
  });

  @override
  List<Object?> get props => [code, error, message];
}

class ServerFailure extends Failure {
  const ServerFailure({
    int? code,
    CraftboxError? error,
  }) : super(code: code, error: error);
}

class AuthorizationFailure extends Failure {}

class UserValidationFailure extends Failure {}

class InternetConnectionFailure extends Failure {}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({String? message}) : super(message: message);
}
