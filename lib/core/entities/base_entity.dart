import 'package:equatable/equatable.dart';

import 'craftbox_error.dart';

class BaseEntity extends Equatable {
  final CraftboxError? error;

  const BaseEntity({this.error});

  @override
  List<Object?> get props => [error];
}
