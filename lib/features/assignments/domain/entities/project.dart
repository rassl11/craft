import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final int id;
  final String title;

  const Project({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
