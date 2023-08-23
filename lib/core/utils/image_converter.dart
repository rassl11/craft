import 'dart:io';
import 'dart:typed_data';

class ImageConverter {

  Future<Uint8List> convertFileToBytes(String fileUrl) async {
    final File imageFile = File(fileUrl);
    if (!imageFile.existsSync()) {
      return Uint8List(0);
    }

    return imageFile.readAsBytes();
  }
}