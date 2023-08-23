import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

abstract class FileLocalDataSource {
  Future<File?> getCachedFile(String fileName);

  Future<File?> writeFileToTempDir(String fileName, Uint8List bytes);
}

class FileLocalDataSourceImpl extends FileLocalDataSource {
  @override
  Future<File?> getCachedFile(String fileName) async {
    final tempDir = (await getTemporaryDirectory()).path;
    final File file = File('$tempDir/$fileName');
    log('Checking cached file...');
    final bool isFileExists = file.existsSync();
    if (!isFileExists) {
      log('Cached file was not found. Path: ${file.path}');
      return null;
    }

    log('Cached file was found. Path: ${file.path}');

    return file;
  }

  @override
  Future<File?> writeFileToTempDir(String fileName, Uint8List bytes) async {
    if (fileName.isEmpty || bytes.isEmpty) {
      return null;
    }

    final tempDir = (await getTemporaryDirectory()).path;
    final File file = File('$tempDir/$fileName');
    return file.writeAsBytes(bytes);
  }
}
