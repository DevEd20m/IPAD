import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/domain/usecases/save_stroke_usecase.dart';
import 'package:ipad/features/drawing/domain/usecases/get_strokes_usecase.dart';
import 'package:ipad/features/drawing/domain/usecases/delete_stroke_usecase.dart';
import 'package:ipad/features/drawing/presentation/viewmodels/drawing_viewmodel.dart';

class MockSaveStrokeUseCase extends Mock implements SaveStrokeUseCase {}
class MockGetStrokesUseCase extends Mock implements GetStrokesUseCase {}
class MockDeleteStrokeUseCase extends Mock implements DeleteStrokeUseCase {}

void main() {
  late DrawingViewModel viewModel;
  late MockSaveStrokeUseCase mockSaveStrokeUseCase;
  late MockGetStrokesUseCase mockGetStrokesUseCase;
  late MockDeleteStrokeUseCase mockDeleteStrokeUseCase;

  setUp(() {
    Get.testMode = true;
    mockSaveStrokeUseCase = MockSaveStrokeUseCase();
    mockGetStrokesUseCase = MockGetStrokesUseCase();
    mockDeleteStrokeUseCase = MockDeleteStrokeUseCase();

    Get.put<SaveStrokeUseCase>(mockSaveStrokeUseCase);
    Get.put<GetStrokesUseCase>(mockGetStrokesUseCase);
    Get.put<DeleteStrokeUseCase>(mockDeleteStrokeUseCase);

    viewModel = DrawingViewModel();
  });

  tearDown(() {
    Get.reset();
  });

  setUpAll(() {
    registerFallbackValue(StrokeEntity(
      id: 'stroke-1',
      documentId: 'doc-1',
      pageIndex: 0,
      toolType: DrawingToolType.pen,
      color: 0xFF000000,
      width: 1.5,
      opacity: 1.0,
      points: const [],
      createdAt: DateTime.now(),
    ));
  });

  group('DrawingViewModel', () {
    test('should have default pen tool', () {
      expect(viewModel.currentTool.value.type, DrawingToolType.pen);
      expect(viewModel.currentTool.value.color, 0xFF000000);
    });

    test('should select pen tool', () {
      viewModel.selectTool(DrawingToolType.pen);

      expect(viewModel.currentTool.value.type, DrawingToolType.pen);
      expect(viewModel.currentTool.value.width, 1.5);
    });

    test('should select pencil tool', () {
      viewModel.selectTool(DrawingToolType.pencil);

      expect(viewModel.currentTool.value.type, DrawingToolType.pencil);
      expect(viewModel.currentTool.value.width, 2.0);
    });

    test('should select marker tool', () {
      viewModel.selectTool(DrawingToolType.marker);

      expect(viewModel.currentTool.value.type, DrawingToolType.marker);
      expect(viewModel.currentTool.value.width, 8.0);
    });

    test('should select eraser tool', () {
      viewModel.selectTool(DrawingToolType.eraser);

      expect(viewModel.currentTool.value.type, DrawingToolType.eraser);
      expect(viewModel.currentTool.value.width, 15.0);
      expect(viewModel.currentTool.value.color, 0xFFFFFFFF);
    });

    test('should set color', () {
      viewModel.setColor(0xFF00FF00);

      expect(viewModel.currentTool.value.color, 0xFF00FF00);
    });

    test('should not set color when eraser is active', () {
      viewModel.selectTool(DrawingToolType.eraser);
      viewModel.setColor(0xFF00FF00);

      expect(viewModel.currentTool.value.color, 0xFFFFFFFF);
    });

    test('should set width', () {
      viewModel.setWidth(5.0);

      expect(viewModel.currentTool.value.width, 5.0);
    });

    test('should start stroke', () {
      viewModel.startStroke(const Offset(10, 20));

      expect(viewModel.isDrawing.value, true);
      expect(viewModel.currentStrokePoints.length, 1);
    });

    test('should add point while drawing', () {
      viewModel.startStroke(const Offset(10, 20));
      viewModel.addPoint(const Offset(30, 40));

      expect(viewModel.currentStrokePoints.length, 2);
    });

    test('should not add point when not drawing', () {
      viewModel.addPoint(const Offset(30, 40));

      expect(viewModel.currentStrokePoints, isEmpty);
    });

    test('should clear current page', () {
      viewModel.currentPageStrokes.add(StrokeEntity(
        id: 'stroke-1',
        documentId: 'doc-1',
        pageIndex: 0,
        toolType: DrawingToolType.pen,
        color: 0xFF000000,
        width: 1.5,
        opacity: 1.0,
        points: const [],
        createdAt: DateTime.now(),
      ));

      viewModel.clearCurrentPage();

      expect(viewModel.currentPageStrokes, isEmpty);
      expect(viewModel.currentStrokePoints, isEmpty);
    });

    test('should handle double tap to switch to eraser', () {
      viewModel.selectTool(DrawingToolType.pen);

      viewModel.handleDoubleTap();

      expect(viewModel.currentTool.value.type, DrawingToolType.eraser);
      expect(viewModel.previousTool.value?.type, DrawingToolType.pen);
    });

    test('should handle double tap to restore previous tool', () {
      viewModel.selectTool(DrawingToolType.pen);
      viewModel.handleDoubleTap();
      viewModel.handleDoubleTap();

      expect(viewModel.currentTool.value.type, DrawingToolType.pen);
      expect(viewModel.previousTool.value, isNull);
    });

    test('should load strokes for page', () async {
      final strokes = [
        StrokeEntity(
          id: 'stroke-1',
          documentId: 'doc-1',
          pageIndex: 0,
          toolType: DrawingToolType.pen,
          color: 0xFF000000,
          width: 1.5,
          opacity: 1.0,
          points: const [],
          createdAt: DateTime.now(),
        ),
      ];

      when(() => mockGetStrokesUseCase(any(), any()))
          .thenAnswer((_) async => strokes);

      viewModel.setCurrentPage('doc-1', 0);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.currentPageStrokes.length, 1);
    });
  });
}
