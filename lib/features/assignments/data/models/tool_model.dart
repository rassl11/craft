import '../../domain/entities/tool.dart';

class ToolModel extends Tool {
  const ToolModel({
    required int id,
    required String manufacturer,
    required String model,
    required String icon,
  }) : super(
          id: id,
          manufacturer: manufacturer,
          model: model,
          icon: icon,
        );

  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
      id: json['id'] as int? ?? 0,
      manufacturer: json['manufacturer'] as String? ?? '',
      model: json['model'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}
