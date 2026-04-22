import 'package:flutter/material.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';

class AppSettingsEntity {
  final ThemeMode themeMode;
  final DrawingTool lastTool;
  final bool doubleTapEnabled;
  final bool doubleTapActivatesEraser;

  const AppSettingsEntity({
    required this.themeMode,
    required this.lastTool,
    required this.doubleTapEnabled,
    required this.doubleTapActivatesEraser,
  });

  AppSettingsEntity copyWith({
    ThemeMode? themeMode,
    DrawingTool? lastTool,
    bool? doubleTapEnabled,
    bool? doubleTapActivatesEraser,
  }) {
    return AppSettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      lastTool: lastTool ?? this.lastTool,
      doubleTapEnabled: doubleTapEnabled ?? this.doubleTapEnabled,
      doubleTapActivatesEraser:
          doubleTapActivatesEraser ?? this.doubleTapActivatesEraser,
    );
  }

  static const AppSettingsEntity defaultSettings = AppSettingsEntity(
    themeMode: ThemeMode.light,
    lastTool: DrawingTool.defaultPen,
    doubleTapEnabled: true,
    doubleTapActivatesEraser: true,
  );
}
