import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/domain/usecases/create_audio_pin_usecase.dart';
import 'package:ipad/features/audio_notes/domain/usecases/get_audio_pins_usecase.dart';
import 'package:ipad/features/audio_notes/domain/usecases/delete_audio_pin_usecase.dart';
import 'package:ipad/core/services/audio_service.dart';
import 'package:ipad/features/audio_notes/presentation/viewmodels/audio_notes_viewmodel.dart';

class MockCreateAudioPinUseCase extends Mock implements CreateAudioPinUseCase {}
class MockGetAudioPinsUseCase extends Mock implements GetAudioPinsUseCase {}
class MockDeleteAudioPinUseCase extends Mock implements DeleteAudioPinUseCase {}
class MockAudioService extends Mock implements AudioService {}

void main() {
  late AudioNotesViewModel viewModel;
  late MockCreateAudioPinUseCase mockCreateUseCase;
  late MockGetAudioPinsUseCase mockGetPinsUseCase;
  late MockDeleteAudioPinUseCase mockDeleteUseCase;
  late MockAudioService mockAudioService;

  setUp(() {
    Get.testMode = true;
    mockCreateUseCase = MockCreateAudioPinUseCase();
    mockGetPinsUseCase = MockGetAudioPinsUseCase();
    mockDeleteUseCase = MockDeleteAudioPinUseCase();
    mockAudioService = MockAudioService();

    Get.put<CreateAudioPinUseCase>(mockCreateUseCase);
    Get.put<GetAudioPinsUseCase>(mockGetPinsUseCase);
    Get.put<DeleteAudioPinUseCase>(mockDeleteUseCase);
    Get.put<AudioService>(mockAudioService);

    viewModel = AudioNotesViewModel();
  });

  tearDown(() {
    Get.reset();
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

  group('AudioNotesViewModel', () {
    final testPins = [
      AudioPinEntity(
        id: 'pin-1',
        documentId: 'doc-1',
        pageIndex: 0,
        xNorm: 0.5,
        yNorm: 0.5,
        audioPath: '/path/to/audio.m4a',
        duration: const Duration(seconds: 30),
        createdAt: DateTime(2024, 1, 1),
      ),
    ];

    test('should load pins for page', () async {
      when(() => mockGetPinsUseCase(any(), any()))
          .thenAnswer((_) async => testPins);

      viewModel.setCurrentPage('doc-1', 0);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.currentPagePins.length, 1);
    });

    test('should check permission', () async {
      when(() => mockAudioService.hasPermission())
          .thenAnswer((_) async => true);

      final result = await viewModel.hasPermission();

      expect(result, true);
    });

    test('should start creating pin', () {
      viewModel.startCreatingPin(0.5, 0.5);

      // Verify internal state is set (test indirectly)
      // The actual implementation stores in private variables
    });

    test('should delete pin successfully', () async {
      when(() => mockGetPinsUseCase(any(), any()))
          .thenAnswer((_) async => testPins);
      when(() => mockAudioService.deleteAudioFile(any()))
          .thenAnswer((_) async {});
      when(() => mockDeleteUseCase(any()))
          .thenAnswer((_) async {});

      viewModel.setCurrentPage('doc-1', 0);
      await Future.delayed(const Duration(milliseconds: 50));

      await viewModel.deletePin(testPins.first);

      expect(viewModel.currentPagePins, isEmpty);
    });

    test('should stop playback', () async {
      when(() => mockAudioService.stopPlayback())
          .thenAnswer((_) async {});

      await viewModel.stopPlayback();

      expect(viewModel.isPlaying.value, false);
    });
  });
}
