import 'package:ipad/features/settings/domain/entities/app_settings_entity.dart';
import 'package:ipad/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository _repository;

  GetSettingsUseCase(this._repository);

  Future<AppSettingsEntity> call() async {
    return await _repository.getSettings();
  }
}
