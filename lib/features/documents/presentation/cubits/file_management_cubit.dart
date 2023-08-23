import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_file/open_file.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/repositories/authentication_repository.dart';
import '../../../../core/utils/failure_helper.dart';
import '../../../../core/utils/file_opener.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/domain/entities/document.dart';
import '../../domain/usecases/get_file.dart';

part 'file_management_state.dart';

class FileManagementCubit extends Cubit<FileManagementState> {
  final GetFile _getFile;
  final FileOpener _fileOpener;
  final AuthenticationRepository _authenticationRepository;

  FileManagementCubit(
    this._getFile,
    this._fileOpener,
    this._authenticationRepository,
  ) : super(const FileManagementState());

  Future<void> getDocument({
    required String fileUrl,
    required String fileName,
    required String title,
    required FileType fileType,
  }) async {
    emit(
      state.copyWith(
        cubitStatus: Status.loading,
        progress: 0,
        title: title,
        fileType: fileType,
      ),
    );

    final fileOrFailure = await _getFile(
      FileParams(
        url: fileUrl,
        fileName: fileName,
        onProgressChanged: (progress) {
          emit(state.copyWith(progress: progress));
        },
      ),
    );

    fileOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          cubitStatus: Status.error,
          errorMsg: mapFailureToMessage(
            failure,
            onAuthenticationFailure: () async {
              await _authenticationRepository.unauthenticate();
            },
          ),
        ),
      ),
      (file) async {
        _handleReceivedFile(file);
      },
    );
  }

  void _handleReceivedFile(File file) {
    if (file.path.isEmpty) {
      emit(
        state.copyWith(
          cubitStatus: Status.error,
          errorMsg: S.current.pathIsEmpty,
        ),
      );
    } else {
      emit(
        state.copyWith(
          cubitStatus: Status.loaded,
          file: file,
          progress: 100,
        ),
      );
    }
  }

  Future<void> openDocument() async {
    final file = state.file;
    if (file == null) {
      emit(
        state.copyWith(
          cubitStatus: Status.error,
          errorMsg: S.current.invalidFile,
        ),
      );
      return;
    }

    final openResult = await _fileOpener.openFile(file);
    if (openResult.type == ResultType.noAppToOpen) {
      emit(
        state.copyWith(
          cubitStatus: Status.error,
          errorMsg: S.current.noAppsToOpen,
        ),
      );
    }
  }
}
