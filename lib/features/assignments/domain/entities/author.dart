import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final int id;
  final String firstName; //first_name
  final String lastName; //last_name

  const Author({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [id, firstName, lastName];
}
