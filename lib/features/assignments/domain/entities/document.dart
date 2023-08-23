import 'package:equatable/equatable.dart';

class Document extends Equatable {
  final int id;
  final int uploadId; //upload_id
  final String title;
  final String icon;
  final Picture? picture;

  const Document({
    required this.id,
    required this.uploadId,
    required this.title,
    required this.icon,
    required this.picture,
  });

  @override
  List<Object?> get props => [id, uploadId, title, icon, picture];
}

class Picture extends Equatable {
  final int id;
  final int fileSize; //file_size
  final String fileOriginalName; //file_original_name
  final String fileName; //file_name
  final String fileMimeType; //file_mime_type
  final FileType fileType; //file_type
  final String thumbUrl; //thumb_url
  final String fileUrl; //file_url
  final String icon;
  final String mediumUrl; //medium_url

  const Picture({
    required this.id,
    required this.fileSize,
    required this.fileOriginalName,
    required this.fileName,
    required this.fileMimeType,
    required this.fileType,
    required this.thumbUrl,
    required this.fileUrl,
    required this.icon,
    required this.mediumUrl,
  });

  @override
  List<Object?> get props =>
      [
        id,
        fileSize,
        fileOriginalName,
        fileName,
        fileMimeType,
        fileType,
        thumbUrl,
        fileUrl,
        icon,
        mediumUrl,
      ];
}

enum FileType {
  pdf('application/pdf'),
  jpg('image/jpeg'),
  gif('image/gif'),
  heic('image/heic'),
  png('image/png'),
  doc('application/msword'),
  docx(
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'),
  mp4('video/mp4'),
  txt('text/plain'),
  xls('application/vnd.ms-excel'),
  xlsx('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
  zip('application/zip'),
  unknown('UNKNOWN');

  final String mimeType;

  const FileType(this.mimeType);
}
