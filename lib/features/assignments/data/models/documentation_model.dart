import 'dart:developer';

import '../../domain/entities/documentation.dart';
import 'author_model.dart';
import 'document_model.dart';

class SingleDocumentationHolderModel extends SingleDocumentationHolder {
  const SingleDocumentationHolderModel({
    required super.documentation,
  });

  factory SingleDocumentationHolderModel.fromJson(Map<String, dynamic> json) {
    return SingleDocumentationHolderModel(
      documentation: DocumentationModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}

class DocumentationModel extends Documentation {
  const DocumentationModel({
    required super.id,
    required super.assignmentId,
    required super.workingTime,
    required super.breakTime,
    required super.drivingTime,
    required super.type,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.upload,
    required super.upload2,
    required super.author,
  });

  const DocumentationModel.postTime({
    required super.assignmentId,
    required super.workingTime,
    required super.breakTime,
    required super.drivingTime,
    required super.type,
    required super.title,
    required super.description,
  });

  const DocumentationModel.postNote({
    required super.assignmentId,
    required super.type,
    required super.title,
    required super.description,
  });

  const DocumentationModel.postEditNote({
    required super.id,
    required super.assignmentId,
    required super.type,
    required super.title,
    required super.description,
  });

  factory DocumentationModel.fromJson(Map<String, dynamic> json) {
    return DocumentationModel(
      id: json['id'] as int,
      assignmentId: json['assignment_id'] as int,
      workingTime: json['working_time'] as int? ?? 0,
      breakTime: json['break_time'] as int? ?? 0,
      drivingTime: json['driving_time'] as int? ?? 0,
      type: DocumentationType.values.firstWhere(
        (type) => type.name == (json['type'] as String).toLowerCase(),
        orElse: () {
          log('Unknown documentation type: ${json['type']}');
          return DocumentationType.unknown;
        },
      ),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      upload: json['upload'] != null
          ? PictureModel.fromJson(json['upload'] as Map<String, dynamic>)
          : null,
      upload2: json['upload2'] != null
          ? PictureModel.fromJson(json['upload2'] as Map<String, dynamic>)
          : null,
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignment_id': assignmentId,
      'working_time': workingTime,
      'break_time': breakTime,
      'driving_time': drivingTime,
      'type': type.name.toUpperCase(),
      'title': title,
      'description': description,
    };
  }

  Map<String, String> toForm() {
    return {
      'assignment_id': assignmentId.toString(),
      'type': type.name.toUpperCase(),
      'title': title,
      'description': description.toString(),
    };
  }
}
