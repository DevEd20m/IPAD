import 'package:ipad/features/settings/domain/entities/app_settings_entity.dart';
import 'package:ipad/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository _repository;

  UpdateSettingsUseCase(this._repository);

  Future<void> call(AppSettingsEntity settings) async {
    await _repository.saveSettings(settings);
  }
}
