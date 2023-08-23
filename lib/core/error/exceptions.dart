import '../entities/craftbox_error.dart';

class ServerException implements Exception {
  final int code;
  final CraftboxError? error;

  ServerException({required this.code, this.error});
}

class AuthorizationException implements Exception {}

class ValidationException implements Exception {}

class UnknownStreamException implements Exception {
  final String message;

  UnknownStreamException(this.message);

  @override
  String toString() {
    return 'UnknownStreamException{message: $message}';
  }
}
