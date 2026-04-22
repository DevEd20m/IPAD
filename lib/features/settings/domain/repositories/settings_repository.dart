import 'package:ipad/features/settings/domain/entities/app_settings_entity.dart';

abstract class SettingsRepository {
  Future<AppSettingsEntity> getSettings();
  Future<void> saveSettings(AppSettingsEntity settings);
}
