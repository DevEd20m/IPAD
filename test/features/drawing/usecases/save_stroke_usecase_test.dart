import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/domain/usecases/save_stroke_usecase.dart';
import 'package:ipad/features/drawing/domain/repositories/stroke_repository.dart';

class MockStrokeRepository extends Mock implements StrokeRepository {}

void main() {
  late SaveStrokeUseCase useCase;
  late MockStrokeRepository mockRepository;

  setUp(() {
    mockRepository = MockStrokeRepository();
    useCase = SaveStrokeUseCase(mockRepository);
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

  group('SaveStrokeUseCase', () {
    final testStroke = StrokeEntity(
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
      createdAt: DateTime(2024, 1, 1),
    );

    test('should call repository saveStroke', () async {
      when(() => mockRepository.saveStroke(any()))
          .thenAnswer((_) async {});

      await useCase(testStroke);

      verify(() => mockRepository.saveStroke(testStroke)).called(1);
    });

    test('should throw exception when save fails', () async {
      when(() => mockRepository.saveStroke(any()))
          .thenThrow(Exception('Save failed'));

      expect(
        () => useCase(testStroke),
        throwsException,
      );
    });
  });
}
