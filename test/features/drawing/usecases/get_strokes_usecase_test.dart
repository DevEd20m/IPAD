import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/domain/usecases/get_strokes_usecase.dart';
import 'package:ipad/features/drawing/domain/repositories/stroke_repository.dart';

class MockStrokeRepository extends Mock implements StrokeRepository {}

void main() {
  late GetStrokesUseCase useCase;
  late MockStrokeRepository mockRepository;

  setUp(() {
    mockRepository = MockStrokeRepository();
    useCase = GetStrokesUseCase(mockRepository);
  });

  group('GetStrokesUseCase', () {
    final testStrokes = [
      StrokeEntity(
        id: 'stroke-1',
        documentId: 'doc-1',
        pageIndex: 0,
        toolType: DrawingToolType.pen,
        color: 0xFF000000,
        width: 1.5,
        opacity: 1.0,
        points: const [DrawingPoint(x: 10, y: 20)],
        createdAt: DateTime(2024, 1, 1),
      ),
      StrokeEntity(
        id: 'stroke-2',
        documentId: 'doc-1',
        pageIndex: 0,
        toolType: DrawingToolType.marker,
        color: 0xFF0000FF,
        width: 8.0,
        opacity: 0.5,
        points: const [DrawingPoint(x: 30, y: 40)],
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    test('should return list of strokes for page', () async {
      when(() => mockRepository.getStrokesForPage(any(), any()))
          .thenAnswer((_) async => testStrokes);

      final result = await useCase('doc-1', 0);

      expect(result, equals(testStrokes));
      verify(() => mockRepository.getStrokesForPage('doc-1', 0)).called(1);
    });

    test('should return empty list when no strokes', () async {
      when(() => mockRepository.getStrokesForPage(any(), any()))
          .thenAnswer((_) async => []);

      final result = await useCase('doc-1', 0);

      expect(result, isEmpty);
      verify(() => mockRepository.getStrokesForPage('doc-1', 0)).called(1);
    });

    test('should throw exception when repository fails', () async {
      when(() => mockRepository.getStrokesForPage(any(), any()))
          .thenThrow(Exception('Failed to load'));

      expect(
        () => useCase('doc-1', 0),
        throwsException,
      );
    });
  });
}
