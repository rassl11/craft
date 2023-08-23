import 'package:equatable/equatable.dart';

class Creation extends Equatable {
  final Causer causer;

  const Creation({
    required this.causer,
  });

  @override
  List<Object?> get props => [causer];
}

class Causer extends Equatable {
  final int id;
  final String firstName; //first_name
  final String lastName; //last_name

  const Causer({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [id, firstName, lastName];
}
