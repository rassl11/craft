import 'package:equatable/equatable.dart';

class Tool extends Equatable {
  final int id;
  final String manufacturer;
  final String model;
  final String icon;

  const Tool({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, manufacturer, model, icon];
}
