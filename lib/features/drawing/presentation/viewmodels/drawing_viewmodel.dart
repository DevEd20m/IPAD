import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipad/core/constants/app_constants.dart';
import 'package:ipad/core/utils/helpers.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/domain/usecases/save_stroke_usecase.dart';
import 'package:ipad/features/drawing/domain/usecases/get_strokes_usecase.dart';
import 'package:ipad/features/drawing/domain/usecases/delete_stroke_usecase.dart';

class DrawingViewModel extends GetxController {
  final SaveStrokeUseCase _saveStrokeUseCase = Get.find();
  final GetStrokesUseCase _getStrokesUseCase = Get.find();
  final DeleteStrokeUseCase _deleteStrokeUseCase = Get.find();

  final Rx<DrawingTool> currentTool = DrawingTool.defaultPen.obs;
  final RxList<StrokeEntity> currentPageStrokes = <StrokeEntity>[].obs;
  final RxList<DrawingPoint> currentStrokePoints = <DrawingPoint>[].obs;
  final RxBool isDrawing = false.obs;
  final Rx<DrawingTool?> previousTool = Rx<DrawingTool?>(null);

  String? _currentDocumentId;
  int _currentPageIndex = 0;

  void setCurrentPage(String documentId, int pageIndex) {
    _currentDocumentId = documentId;
    _currentPageIndex = pageIndex;
    loadStrokesForPage();
  }

  Future<void> loadStrokesForPage() async {
    if (_currentDocumentId == null) return;
    
    final strokes = await _getStrokesUseCase(_currentDocumentId!, _currentPageIndex);
    currentPageStrokes.assignAll(strokes);
  }

  void selectTool(DrawingToolType type) {
    final color = currentTool.value.color;
    double width;
    double opacity = 1.0;

    switch (type) {
      case DrawingToolType.pen:
        width = 1.5;
        break;
      case DrawingToolType.pencil:
        width = 2.0;
        break;
      case DrawingToolType.marker:
        width = 8.0;
        opacity = AppConstants.markerOpacity;
        break;
      case DrawingToolType.eraser:
        width = 15.0;
        break;
    }

    currentTool.value = DrawingTool(
      type: type,
      color: type == DrawingToolType.eraser ? 0xFFFFFFFF : color,
      width: width,
      opacity: opacity,
    );
  }

  void setColor(int color) {
    if (currentTool.value.type != DrawingToolType.eraser) {
      currentTool.value = currentTool.value.copyWith(color: color);
    }
  }

  void setWidth(double width) {
    currentTool.value = currentTool.value.copyWith(width: width);
  }

  void startStroke(Offset position) {
    isDrawing.value = true;
    currentStrokePoints.clear();
    currentStrokePoints.add(DrawingPoint(x: position.dx, y: position.dy));
  }

  void addPoint(Offset position, {double pressure = 1.0}) {
    if (isDrawing.value) {
      currentStrokePoints.add(DrawingPoint(
        x: position.dx,
        y: position.dy,
        pressure: pressure,
      ));
    }
  }

  Future<void> endStroke() async {
    if (!isDrawing.value || currentStrokePoints.isEmpty) {
      isDrawing.value = false;
      currentStrokePoints.clear();
      return;
    }

    final tool = currentTool.value;
    
    if (tool.type == DrawingToolType.eraser) {
      await _eraseAtPoints();
    } else {
      await _saveCurrentStroke();
    }

    isDrawing.value = false;
    currentStrokePoints.clear();
  }

  Future<void> _saveCurrentStroke() async {
    if (_currentDocumentId == null || currentStrokePoints.isEmpty) return;

    final stroke = StrokeEntity(
      id: IdGenerator.generate(),
      documentId: _currentDocumentId!,
      pageIndex: _currentPageIndex,
      toolType: currentTool.value.type,
      color: currentTool.value.color,
      width: currentTool.value.width,
      opacity: currentTool.value.opacity,
      points: List.from(currentStrokePoints),
      createdAt: DateTime.now(),
    );

    await _saveStrokeUseCase(stroke);
    currentPageStrokes.add(stroke);
  }

  Future<void> _eraseAtPoints() async {
    if (_currentDocumentId == null || currentStrokePoints.isEmpty) return;

    final eraserWidth = currentTool.value.width;
    final eraserCenter = currentStrokePoints[currentStrokePoints.length ~/ 2];

    final strokesToRemove = currentPageStrokes.where((stroke) {
      for (final point in stroke.points) {
        final distance = _distance(
          eraserCenter.x,
          eraserCenter.y,
          point.x,
          point.y,
        );
        if (distance < eraserWidth) {
          return true;
        }
      }
      return false;
    }).toList();

    for (final stroke in strokesToRemove) {
      await _deleteStrokeUseCase(stroke.id);
      currentPageStrokes.removeWhere((s) => s.id == stroke.id);
    }
  }

  double _distance(double x1, double y1, double x2, double y2) {
    return ((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
  }

  void handleDoubleTap() {
    if (currentTool.value.type == DrawingToolType.eraser) {
      if (previousTool.value != null) {
        currentTool.value = previousTool.value!;
        previousTool.value = null;
      } else {
        selectTool(DrawingToolType.pen);
      }
    } else {
      previousTool.value = currentTool.value;
      selectTool(DrawingToolType.eraser);
    }
  }

  void clearCurrentPage() {
    currentPageStrokes.clear();
    currentStrokePoints.clear();
  }

  @override
  void onClose() {
    currentPageStrokes.clear();
    currentStrokePoints.clear();
    super.onClose();
  }
}
