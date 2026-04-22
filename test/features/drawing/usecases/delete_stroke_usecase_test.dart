import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/drawing/domain/usecases/delete_stroke_usecase.dart';
import 'package:ipad/features/drawing/domain/repositories/stroke_repository.dart';

class MockStrokeRepository extends Mock implements StrokeRepository {}

void main() {
  late DeleteStrokeUseCase useCase;
  late MockStrokeRepository mockRepository;

  setUp(() {
    mockRepository = MockStrokeRepository();
    useCase = DeleteStrokeUseCase(mockRepository);
  });

  group('DeleteStrokeUseCase', () {
    test('should call repository deleteStroke', () async {
      when(() => mockRepository.deleteStroke(any()))
          .thenAnswer((_) async {});

      await useCase('stroke-1');

      verify(() => mockRepository.deleteStroke('stroke-1')).called(1);
    });

    test('should throw exception when deletion fails', () async {
      when(() => mockRepository.deleteStroke(any()))
          .thenThrow(Exception('Delete failed'));

      expect(
        () => useCase('stroke-1'),
        throwsException,
      );
    });
  });
}
