import 'dart:math';

class NumericUtils {
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) {
      return '0 B';
    }

    const suffixesList = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final suffixIndex = (log(bytes) / log(1024)).floor();
    final size = (bytes / pow(1024, suffixIndex)).toStringAsFixed(decimals);
    final suffix = suffixesList[suffixIndex];

    return '$size$suffix';
  }
}
