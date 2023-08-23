import '../../domain/entities/login.dart';

class LoginModel extends Login {
  const LoginModel({
    required String accessToken,
    required String tokenType,
  }) : super(accessToken: accessToken, tokenType: tokenType);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json['access_token'].toString(),
      tokenType: json['token_type'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }
}
