import '../entities/craftbox_error.dart';

class CraftboxErrorModel extends CraftboxError {
  const CraftboxErrorModel({
    required String code,
    required String httpCode,
    required String message,
    required String displayMessage,
  }) : super(
          code: code,
          httpCode: httpCode,
          message: message,
          displayMessage: displayMessage,
        );

  factory CraftboxErrorModel.fromJson(Map<String, dynamic> json) {
    return CraftboxErrorModel(
      code: json['code'].toString(),
      httpCode: json['http_code'].toString(),
      message: json['message'].toString(),
      displayMessage: json['display_message'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'http_code': httpCode,
      'message': message,
      'display_message': displayMessage,
    };
  }
}
