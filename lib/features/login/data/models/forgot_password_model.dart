import '../../domain/entities/forgot_password.dart';

class ForgotPasswordModel extends ForgotPassword {
  const ForgotPasswordModel({required String? success})
      : super(success: success);

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(success: json['success'] as String?);
  }
}
