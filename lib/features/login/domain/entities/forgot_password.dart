import 'package:equatable/equatable.dart';

class ForgotPassword extends Equatable {
  final String? success;

  const ForgotPassword({required this.success});

  @override
  List<Object?> get props => [success];
}
