import '../../domain/entities/document.dart';

class DocumentModel extends Document {
  const DocumentModel({
    required int id,
    required int uploadId,
    required String title,
    required String icon,
    required PictureModel? picture,
  }) : super(
          id: id,
          uploadId: uploadId,
          title: title,
          icon: icon,
          picture: picture,
        );

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as int? ?? 0,
      uploadId: json['upload_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      picture: json['picture'] != null
          ? PictureModel.fromJson(json['picture'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PictureModel extends Picture {
  const PictureModel({
    required int id,
    required int fileSize,
    required String fileOriginalName,
    required String fileName,
    required String fileMimeType,
    required FileType fileType,
    required String thumbUrl,
    required String fileUrl,
    required String icon,
    required String mediumUrl,
  }) : super(
    id: id,
          fileSize: fileSize,
          fileOriginalName: fileOriginalName,
          fileName: fileName,
          fileMimeType: fileMimeType,
          fileType: fileType,
          thumbUrl: thumbUrl,
          fileUrl: fileUrl,
          icon: icon,
          mediumUrl: mediumUrl,
        );

  factory PictureModel.fromJson(Map<String, dynamic> json) {
    return PictureModel(
      id: json['id'] as int? ?? 0,
      fileSize: json['file_size'] as int? ?? 0,
      fileOriginalName: json['file_original_name'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
      fileMimeType: json['file_mime_type'] as String? ?? '',
      fileType: FileType.values.firstWhere(
        (type) {
          final mimeType = json['file_mime_type'] as String? ?? '';
          return type.mimeType == mimeType;
        },
        orElse: () => FileType.unknown,
      ),
      thumbUrl: json['thumb_url'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      mediumUrl: json['medium_url'] as String? ?? '',
    );
  }
}
