import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final String accessToken;
  final String tokenType;

  const Login({required this.accessToken, required this.tokenType});

  @override
  List<Object?> get props => [accessToken, tokenType];
}
