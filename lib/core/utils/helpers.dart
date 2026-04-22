import 'package:uuid/uuid.dart';

class IdGenerator {
  static const _uuid = Uuid();

  static String generate() => _uuid.v4();
}

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class CoordinateUtils {
  static Map<String, double> normalize({
    required double x,
    required double y,
    required double width,
    required double height,
  }) {
    return {
      'xNorm': x / width,
      'yNorm': y / height,
    };
  }

  static Map<String, double> denormalize({
    required double xNorm,
    required double yNorm,
    required double width,
    required double height,
  }) {
    return {
      'x': xNorm * width,
      'y': yNorm * height,
    };
  }
}
