import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/shared_prefs.dart';
import '../../../../core/sources/base_remote_data_source.dart';

abstract class FileRemoteDataSource {
  Future<Uint8List> downloadFile(String url, Function(int) setProgress);
}

class FileRemoteDataSourceImpl extends BaseRemoteDataSource
    implements FileRemoteDataSource {
  final http.Client _client;

  FileRemoteDataSourceImpl({
    required http.Client client,
    required SharedPrefs sharedPrefs,
    required PackageInfo packageInfo,
  })  : _client = client,
        super(
          sharedPrefs: sharedPrefs,
          packageInfo: packageInfo,
        );

  @override
  Future<Uint8List> downloadFile(
    String url,
    Function(int) onProgressChanged,
  ) async {
    final request = http.Request('GET', Uri.parse(url));
    final response = _client.send(request);

    final Completer<Uint8List> completer = Completer();
    final List<List<int>> chunks = [];
    int downloaded = 0;
    response.asStream().listen(
      (streamResponse) {
        final contentLength = streamResponse.contentLength;
        streamResponse.stream.listen(
          (List<int> chunk) {
            final progress = downloaded / (contentLength ?? 1) * 100;
            onProgressChanged(progress.toInt());

            chunks.add(chunk);
            downloaded += chunk.length;
          },
          onDone: () async {
            handleStreamedResponse(streamResponse, onSuccess: () {
              completer.complete(_getBytesList(contentLength, chunks));
            }, onFailure: (exception) {
              completer.completeError(exception);
            });

            return;
          },
          onError: (error) {
            _onError(error, completer);
          },
          cancelOnError: true,
        );
      },
      onError: (error) {
        _onError(error, completer);
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  Uint8List _getBytesList(int? contentLength, List<List<int>> chunks) {
    int offset = 0;
    final Uint8List bytes = Uint8List(contentLength ?? 0);
    for (final List<int> chunk in chunks) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return bytes;
  }

  void _onError(error, Completer<Uint8List> completer) {
    log('Streamed response error: $error');
    completer.completeError(UnknownStreamException(error.toString()));
  }
}
