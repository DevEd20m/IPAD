import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/presentation/viewmodels/drawing_viewmodel.dart';

class DrawingCanvas extends StatelessWidget {
  final DrawingViewModel viewModel;
  final VoidCallback onDoubleTap;

  const DrawingCanvas({
    super.key,
    required this.viewModel,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onPanStart: (details) {
        viewModel.startStroke(details.localPosition);
      },
      onPanUpdate: (details) {
        viewModel.addPoint(details.localPosition);
      },
      onPanEnd: (details) {
        viewModel.endStroke();
      },
      child: Obx(() => CustomPaint(
        painter: _DrawingPainter(
          strokes: viewModel.currentPageStrokes,
          currentPoints: viewModel.currentStrokePoints.toList(),
          currentTool: viewModel.currentTool.value,
          isDrawing: viewModel.isDrawing.value,
        ),
        size: Size.infinite,
      )),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<StrokeEntity> strokes;
  final List<DrawingPoint> currentPoints;
  final DrawingTool currentTool;
  final bool isDrawing;

  _DrawingPainter({
    required this.strokes,
    required this.currentPoints,
    required this.currentTool,
    required this.isDrawing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }

    if (isDrawing && currentPoints.isNotEmpty) {
      _drawCurrentStroke(canvas);
    }
  }

  void _drawStroke(Canvas canvas, StrokeEntity stroke) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = Color(stroke.color).withOpacity(stroke.opacity)
      ..strokeWidth = stroke.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (stroke.toolType == DrawingToolType.eraser) {
      paint.blendMode = BlendMode.clear;
    }

    final path = Path();
    path.moveTo(stroke.points.first.x, stroke.points.first.y);

    for (int i = 1; i < stroke.points.length; i++) {
      final p0 = stroke.points[i - 1];
      final p1 = stroke.points[i];
      
      final midX = (p0.x + p1.x) / 2;
      final midY = (p0.y + p1.y) / 2;
      
      path.quadraticBezierTo(p0.x, p0.y, midX, midY);
    }

    canvas.drawPath(path, paint);
  }

  void _drawCurrentStroke(Canvas canvas) {
    if (currentPoints.isEmpty) return;

    final paint = Paint()
      ..color = Color(currentTool.color).withOpacity(currentTool.opacity)
      ..strokeWidth = currentTool.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (currentTool.type == DrawingToolType.eraser) {
      paint.blendMode = BlendMode.clear;
    }

    final path = Path();
    path.moveTo(currentPoints.first.x, currentPoints.first.y);

    for (int i = 1; i < currentPoints.length; i++) {
      final p0 = currentPoints[i - 1];
      final p1 = currentPoints[i];
      
      final midX = (p0.x + p1.x) / 2;
      final midY = (p0.y + p1.y) / 2;
      
      path.quadraticBezierTo(p0.x, p0.y, midX, midY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return true;
  }
}
