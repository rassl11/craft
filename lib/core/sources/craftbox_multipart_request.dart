import 'package:http/http.dart' as http;

class CraftboxMultipartRequest {
  CraftboxMultipartRequest();

  http.MultipartRequest getMultipartRequest({
    required String method,
    required Uri url,
    required Map<String, String> headers,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) {
    final request = http.MultipartRequest(method, url);
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    request.files.addAll(files);
    return request;
  }
}
