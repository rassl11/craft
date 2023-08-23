import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';

import '../../features/assignments/domain/entities/document.dart';
import '../../features/documents/presentation/cubits/file_management_cubit.dart';
import '../blocs/status.dart';
import '../screens/media_viewer.dart';
import 'ui_utils.dart';

class FileOpener {
  void checkStatusAndOpenFile(FileManagementState state, BuildContext context) {
    switch (state.cubitStatus) {
      case Status.loaded:
        _handleFile(state, context);
        break;
      case Status.error:
        showSnackBarWithText(context, state.errorMsg);
        break;
      default:
        break;
    }
  }

  void _handleFile(FileManagementState state, BuildContext context) {
    final receivedFile = state.file;
    if (receivedFile == null) {
      return;
    }

    switch (state.fileType) {
      case FileType.jpg:
      case FileType.gif:
      case FileType.png:
      case FileType.heic:
        Navigator.of(context).pushNamed(
          MediaViewer.routeName,
          arguments: MediaArgs(
            file: receivedFile,
            title: state.title,
          ),
        );
        break;
      default:
        context.read<FileManagementCubit>().openDocument();
        break;
    }
  }

  Future<OpenResult> openFile(File file) async {
    return OpenFile.open(file.path);
  }
}
