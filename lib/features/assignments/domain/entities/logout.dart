import 'package:equatable/equatable.dart';

class Logout extends Equatable {
  final String? success;

  const Logout({required this.success});

  @override
  List<Object?> get props => [success];
}
