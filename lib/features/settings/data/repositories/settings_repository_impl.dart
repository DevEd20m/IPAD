import 'package:ipad/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:ipad/features/settings/domain/entities/app_settings_entity.dart';
import 'package:ipad/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<AppSettingsEntity> getSettings() async {
    return await _dataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {
    await _dataSource.saveSettings(settings);
  }
}
