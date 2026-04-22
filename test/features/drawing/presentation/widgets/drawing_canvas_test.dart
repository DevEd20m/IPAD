import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/domain/usecases/save_stroke_usecase.dart';
import 'package:ipad/features/drawing/domain/usecases/get_strokes_usecase.dart';
import 'package:ipad/features/drawing/domain/usecases/delete_stroke_usecase.dart';
import 'package:ipad/features/drawing/presentation/viewmodels/drawing_viewmodel.dart';
import 'package:ipad/features/drawing/presentation/widgets/drawing_canvas.dart';

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

  group('DrawingCanvas Widget', () {
    testWidgets('should render canvas', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawingCanvas(
              viewModel: viewModel,
              onDoubleTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(DrawingCanvas), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('should handle pan gestures', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: DrawingCanvas(
                viewModel: viewModel,
                onDoubleTap: () {},
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(const Offset(100, 100));
      await tester.pump();

      expect(viewModel.isDrawing.value, true);

      await gesture.moveBy(const Offset(50, 50));
      await tester.pump();

      await gesture.up();
      await tester.pump();
    });

    testWidgets('should handle double tap', (tester) async {
      bool doubleTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawingCanvas(
              viewModel: viewModel,
              onDoubleTap: () {
                doubleTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DrawingCanvas));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(DrawingCanvas));
      await tester.pumpAndSettle();

      expect(doubleTapped, true);
    });

    testWidgets('should render strokes', (tester) async {
      viewModel.currentPageStrokes.add(StrokeEntity(
        id: 'stroke-1',
        documentId: 'doc-1',
        pageIndex: 0,
        toolType: DrawingToolType.pen,
        color: 0xFF000000,
        width: 1.5,
        opacity: 1.0,
        points: const [
          DrawingPoint(x: 10, y: 20),
          DrawingPoint(x: 30, y: 40),
        ],
        createdAt: DateTime.now(),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawingCanvas(
              viewModel: viewModel,
              onDoubleTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(DrawingCanvas), findsOneWidget);
    });
  });
}
