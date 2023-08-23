import 'package:equatable/equatable.dart';

import 'author.dart';
import 'document.dart';

class SingleDocumentationHolder extends Equatable {
  final Documentation documentation;

  const SingleDocumentationHolder({
    required this.documentation,
  });

  @override
  List<Object?> get props => [documentation];
}

class Documentation extends Equatable {
  final int? id; //id
  final int assignmentId; //assignment_id
  final int? workingTime; //working_time
  final int? breakTime; //break_time
  final int? drivingTime; //driving_time
  final DocumentationType type;
  final String title;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Picture? upload;
  final Picture? upload2;
  final Author? author;

  const Documentation({
    this.id,
    required this.assignmentId,
    this.workingTime,
    this.breakTime,
    this.drivingTime,
    required this.type,
    required this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.upload,
    this.upload2,
    this.author,
  });

  @override
  List<Object?> get props =>
      [
        id,
        assignmentId,
        workingTime,
        breakTime,
        drivingTime,
        type,
        title,
        description,
        createdAt,
        updatedAt,
        upload,
        upload2,
        author,
      ];
}

enum DocumentationType {
  note,
  photo,
  signing,
  drawing,
  time,
  pdf,
  draft,
  attachment,
  material,
  unknown
}
