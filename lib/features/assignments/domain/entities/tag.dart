import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int id;
  final String name;
  final String color;
  final String icon;
  final DateTime createdAt; //created_at
  final DateTime updatedAt; //updated_at

  const Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, color, icon, createdAt, updatedAt];
}
