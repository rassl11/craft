import '../../domain/entities/logout.dart';

class LogoutModel extends Logout {
  const LogoutModel({
    required String? success,
  }) : super(success: success);

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      success: json['success'] as String?,
    );
  }
}
