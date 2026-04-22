import 'package:flutter/material.dart';
import 'package:ipad/core/services/storage_service.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/settings/domain/entities/app_settings_entity.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettingsEntity> getSettings();
  Future<void> saveSettings(AppSettingsEntity settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'app_settings';

  @override
  Future<AppSettingsEntity> getSettings() async {
    final box = StorageService.getSettingsBox();
    final json = box.get(_settingsKey);
    
    if (json == null) {
      return AppSettingsEntity.defaultSettings;
    }
    
    final map = Map<String, dynamic>.from(json);
    return AppSettingsEntity(
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == map['themeMode'],
        orElse: () => ThemeMode.light,
      ),
      lastTool: DrawingTool(
        type: DrawingToolType.values.firstWhere(
          (e) => e.name == map['lastToolType'],
          orElse: () => DrawingToolType.pen,
        ),
        color: map['lastToolColor'] as int? ?? 0xFF000000,
        width: (map['lastToolWidth'] as num?)?.toDouble() ?? 1.5,
      ),
      doubleTapEnabled: map['doubleTapEnabled'] as bool? ?? true,
      doubleTapActivatesEraser: map['doubleTapActivatesEraser'] as bool? ?? true,
    );
  }

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {
    final box = StorageService.getSettingsBox();
    await box.put(_settingsKey, {
      'themeMode': settings.themeMode.name,
      'lastToolType': settings.lastTool.type.name,
      'lastToolColor': settings.lastTool.color,
      'lastToolWidth': settings.lastTool.width,
      'doubleTapEnabled': settings.doubleTapEnabled,
      'doubleTapActivatesEraser': settings.doubleTapActivatesEraser,
    });
  }
}
