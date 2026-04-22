import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/settings/domain/entities/app_settings_entity.dart';
import 'package:ipad/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:ipad/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:ipad/features/settings/presentation/viewmodels/settings_viewmodel.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}
class MockUpdateSettingsUseCase extends Mock implements UpdateSettingsUseCase {}

void main() {
  late SettingsViewModel viewModel;
  late MockGetSettingsUseCase mockGetSettingsUseCase;
  late MockUpdateSettingsUseCase mockUpdateSettingsUseCase;

  setUp(() {
    Get.testMode = true;
    mockGetSettingsUseCase = MockGetSettingsUseCase();
    mockUpdateSettingsUseCase = MockUpdateSettingsUseCase();

    Get.put<GetSettingsUseCase>(mockGetSettingsUseCase);
    Get.put<UpdateSettingsUseCase>(mockUpdateSettingsUseCase);

    viewModel = SettingsViewModel();
  });

  tearDown(() {
    Get.reset();
  });

  setUpAll(() {
    registerFallbackValue(AppSettingsEntity.defaultSettings);
  });

  group('SettingsViewModel', () {
    final testSettings = AppSettingsEntity(
      themeMode: ThemeMode.light,
      lastTool: DrawingTool.defaultPen,
      doubleTapEnabled: true,
      doubleTapActivatesEraser: true,
    );

    test('should load settings on init', () async {
      when(() => mockGetSettingsUseCase())
          .thenAnswer((_) async => testSettings);

      viewModel.onInit();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.settings.value.themeMode, ThemeMode.light);
      expect(viewModel.settings.value.doubleTapEnabled, true);
    });

    test('should set theme mode', () async {
      when(() => mockGetSettingsUseCase())
          .thenAnswer((_) async => testSettings);
      when(() => mockUpdateSettingsUseCase(any()))
          .thenAnswer((_) async {});

      viewModel.onInit();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.setThemeMode(ThemeMode.dark);

      expect(viewModel.settings.value.themeMode, ThemeMode.dark);
    });

    test('should set double tap enabled', () async {
      when(() => mockGetSettingsUseCase())
          .thenAnswer((_) async => testSettings);
      when(() => mockUpdateSettingsUseCase(any()))
          .thenAnswer((_) async {});

      viewModel.onInit();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.setDoubleTapEnabled(false);

      expect(viewModel.settings.value.doubleTapEnabled, false);
    });

    test('should set double tap activates eraser', () async {
      when(() => mockGetSettingsUseCase())
          .thenAnswer((_) async => testSettings);
      when(() => mockUpdateSettingsUseCase(any()))
          .thenAnswer((_) async {});

      viewModel.onInit();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.setDoubleTapActivatesEraser(false);

      expect(viewModel.settings.value.doubleTapActivatesEraser, false);
    });

    test('should set last tool', () async {
      when(() => mockGetSettingsUseCase())
          .thenAnswer((_) async => testSettings);
      when(() => mockUpdateSettingsUseCase(any()))
          .thenAnswer((_) async {});

      viewModel.onInit();
      await Future.delayed(const Duration(milliseconds: 100));

      final newTool = DrawingTool(
        type: DrawingToolType.marker,
        color: 0xFF00FF00,
        width: 8.0,
      );

      await viewModel.setLastTool(newTool);

      expect(viewModel.settings.value.lastTool.type, DrawingToolType.marker);
    });
  });
}
