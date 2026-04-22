import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/audio_notes/domain/usecases/delete_audio_pin_usecase.dart';
import 'package:ipad/features/audio_notes/domain/repositories/audio_pin_repository.dart';

class MockAudioPinRepository extends Mock implements AudioPinRepository {}

void main() {
  late DeleteAudioPinUseCase useCase;
  late MockAudioPinRepository mockRepository;

  setUp(() {
    mockRepository = MockAudioPinRepository();
    useCase = DeleteAudioPinUseCase(mockRepository);
  });

  group('DeleteAudioPinUseCase', () {
    test('should call repository deleteAudioPin', () async {
      when(() => mockRepository.deleteAudioPin(any()))
          .thenAnswer((_) async {});

      await useCase('pin-1');

      verify(() => mockRepository.deleteAudioPin('pin-1')).called(1);
    });

    test('should throw exception when deletion fails', () async {
      when(() => mockRepository.deleteAudioPin(any()))
          .thenThrow(Exception('Delete failed'));

      expect(
        () => useCase('pin-1'),
        throwsException,
      );
    });
  });
}
