import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required int id,
    required String title,
  }) : super(
          id: id,
          title: title,
        );

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
    );
  }
}
