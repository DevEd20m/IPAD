import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String documentsBox = 'documents';
  static const String settingsBox = 'settings';
  static const String strokesBox = 'strokes';
  static const String audioPinsBox = 'audioPins';

  static Future<void> init() async {
    await Hive.initFlutter();
    await _registerAdapters();
    await _openBoxes();
  }

  static Future<void> _registerAdapters() async {
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox(documentsBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox(strokesBox);
    await Hive.openBox(audioPinsBox);
  }

  static Box getDocumentsBox() => Hive.box(documentsBox);
  static Box getSettingsBox() => Hive.box(settingsBox);
  static Box getStrokesBox() => Hive.box(strokesBox);
  static Box getAudioPinsBox() => Hive.box(audioPinsBox);

  static Future<void> close() async {
    await Hive.close();
  }
}
