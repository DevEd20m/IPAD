import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/domain/usecases/get_audio_pins_usecase.dart';
import 'package:ipad/features/audio_notes/domain/repositories/audio_pin_repository.dart';

class MockAudioPinRepository extends Mock implements AudioPinRepository {}

void main() {
  late GetAudioPinsUseCase useCase;
  late MockAudioPinRepository mockRepository;

  setUp(() {
    mockRepository = MockAudioPinRepository();
    useCase = GetAudioPinsUseCase(mockRepository);
  });

  group('GetAudioPinsUseCase', () {
    final testPins = [
      AudioPinEntity(
        id: 'pin-1',
        documentId: 'doc-1',
        pageIndex: 0,
        xNorm: 0.5,
        yNorm: 0.5,
        audioPath: '/path/to/audio1.m4a',
        duration: const Duration(seconds: 30),
        createdAt: DateTime(2024, 1, 1),
      ),
      AudioPinEntity(
        id: 'pin-2',
        documentId: 'doc-1',
        pageIndex: 0,
        xNorm: 0.3,
        yNorm: 0.7,
        audioPath: '/path/to/audio2.m4a',
        duration: const Duration(seconds: 45),
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    test('should return list of audio pins for page', () async {
      when(() => mockRepository.getAudioPinsForPage(any(), any()))
          .thenAnswer((_) async => testPins);

      final result = await useCase('doc-1', 0);

      expect(result, equals(testPins));
      verify(() => mockRepository.getAudioPinsForPage('doc-1', 0)).called(1);
    });

    test('should return empty list when no pins', () async {
      when(() => mockRepository.getAudioPinsForPage(any(), any()))
          .thenAnswer((_) async => []);

      final result = await useCase('doc-1', 0);

      expect(result, isEmpty);
      verify(() => mockRepository.getAudioPinsForPage('doc-1', 0)).called(1);
    });

    test('should throw exception when repository fails', () async {
      when(() => mockRepository.getAudioPinsForPage(any(), any()))
          .thenThrow(Exception('Failed to load'));

      expect(
        () => useCase('doc-1', 0),
        throwsException,
      );
    });
  });
}
