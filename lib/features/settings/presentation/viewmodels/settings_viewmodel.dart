import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/settings/domain/entities/app_settings_entity.dart';
import 'package:ipad/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:ipad/features/settings/domain/usecases/update_settings_usecase.dart';

class SettingsViewModel extends GetxController {
  final GetSettingsUseCase _getSettingsUseCase = Get.find();
  final UpdateSettingsUseCase _updateSettingsUseCase = Get.find();

  final Rx<AppSettingsEntity> settings = AppSettingsEntity.defaultSettings.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    isLoading.value = true;
    try {
      final result = await _getSettingsUseCase();
      settings.value = result;
      _applyTheme(result.themeMode);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final updated = settings.value.copyWith(themeMode: mode);
    await _saveSettings(updated);
    _applyTheme(mode);
  }

  Future<void> setLastTool(DrawingTool tool) async {
    final updated = settings.value.copyWith(lastTool: tool);
    await _saveSettings(updated);
  }

  Future<void> setDoubleTapEnabled(bool enabled) async {
    final updated = settings.value.copyWith(doubleTapEnabled: enabled);
    await _saveSettings(updated);
  }

  Future<void> setDoubleTapActivatesEraser(bool activates) async {
    final updated = settings.value.copyWith(doubleTapActivatesEraser: activates);
    await _saveSettings(updated);
  }

  Future<void> _saveSettings(AppSettingsEntity settings) async {
    await _updateSettingsUseCase(settings);
    this.settings.value = settings;
  }

  void _applyTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
  }

  @override
  void onClose() {
    settings.close();
    super.onClose();
  }
}
