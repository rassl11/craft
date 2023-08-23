part of 'file_management_cubit.dart';

class FileManagementState extends Equatable {
  final int progress;
  final Status cubitStatus;
  final File? file;
  final String title;
  final String errorMsg;
  final FileType fileType;

  const FileManagementState({
    this.progress = 0,
    this.cubitStatus = Status.initial,
    this.file,
    this.title = '',
    this.errorMsg = '',
    this.fileType = FileType.unknown,
  });

  @override
  List<Object?> get props => [
        progress,
        cubitStatus,
        file,
        title,
        errorMsg,
        fileType,
      ];

  FileManagementState copyWith({
    int? progress,
    Status? cubitStatus,
    File? file,
    String? title,
    String? errorMsg,
    FileType? fileType,
  }) {
    return FileManagementState(
      progress: progress ?? this.progress,
      cubitStatus: cubitStatus ?? this.cubitStatus,
      file: file ?? this.file,
      title: title ?? this.title,
      errorMsg: errorMsg ?? this.errorMsg,
      fileType: fileType ?? this.fileType,
    );
  }
}
