import 'package:equatable/equatable.dart';

class CraftboxError extends Equatable {
  final String code;
  final String httpCode; //http_code
  final String message;
  final String displayMessage; //display_message

  const CraftboxError({
    required this.code,
    required this.httpCode,
    required this.message,
    required this.displayMessage,
  });

  @override
  List<Object?> get props => [code, httpCode, message, displayMessage];
}
