import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/domain/usecases/create_audio_pin_usecase.dart';
import 'package:ipad/features/audio_notes/domain/repositories/audio_pin_repository.dart';

class MockAudioPinRepository extends Mock implements AudioPinRepository {}

void main() {
  late CreateAudioPinUseCase useCase;
  late MockAudioPinRepository mockRepository;

  setUp(() {
    mockRepository = MockAudioPinRepository();
    useCase = CreateAudioPinUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(AudioPinEntity(
      id: 'pin-1',
      documentId: 'doc-1',
      pageIndex: 0,
      xNorm: 0.5,
      yNorm: 0.5,
      audioPath: '/path/to/audio.m4a',
      duration: const Duration(seconds: 30),
      createdAt: DateTime.now(),
    ));
  });

  group('CreateAudioPinUseCase', () {
    final testAudioPin = AudioPinEntity(
      id: 'pin-1',
      documentId: 'doc-1',
      pageIndex: 0,
      xNorm: 0.5,
      yNorm: 0.5,
      audioPath: '/path/to/audio.m4a',
      duration: const Duration(seconds: 30),
      createdAt: DateTime(2024, 1, 1),
    );

    test('should return audio pin when creation is successful', () async {
      when(() => mockRepository.createAudioPin(any()))
          .thenAnswer((_) async => testAudioPin);

      final result = await useCase(testAudioPin);

      expect(result, equals(testAudioPin));
      verify(() => mockRepository.createAudioPin(testAudioPin)).called(1);
    });

    test('should throw exception when creation fails', () async {
      when(() => mockRepository.createAudioPin(any()))
          .thenThrow(Exception('Create failed'));

      expect(
        () => useCase(testAudioPin),
        throwsException,
      );
    });
  });
}
