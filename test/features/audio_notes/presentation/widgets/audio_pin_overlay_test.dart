import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/domain/usecases/create_audio_pin_usecase.dart';
import 'package:ipad/features/audio_notes/domain/usecases/get_audio_pins_usecase.dart';
import 'package:ipad/features/audio_notes/domain/usecases/delete_audio_pin_usecase.dart';
import 'package:ipad/core/services/audio_service.dart';
import 'package:ipad/features/audio_notes/presentation/viewmodels/audio_notes_viewmodel.dart';
import 'package:ipad/features/audio_notes/presentation/widgets/audio_pin_overlay.dart';

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

  group('AudioPinOverlay Widget', () {
    testWidgets('should render overlay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 400,
              child: AudioPinOverlay(
                viewModel: viewModel,
                zoom: 1.0,
                onPinTap: (pin) {},
                onPinDelete: (pin) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AudioPinOverlay), findsOneWidget);
    });

    testWidgets('should render pins when available', (tester) async {
      final pins = [
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

      viewModel.currentPagePins.addAll(pins);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 400,
              child: AudioPinOverlay(
                viewModel: viewModel,
                zoom: 1.0,
                onPinTap: (pin) {},
                onPinDelete: (pin) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('should show playing icon when pin is playing', (tester) async {
      final pins = [
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

      viewModel.currentPagePins.addAll(pins);
      viewModel.playingPinId?.value = 'pin-1';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 400,
              child: AudioPinOverlay(
                viewModel: viewModel,
                zoom: 1.0,
                onPinTap: (pin) {},
                onPinDelete: (pin) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('should call onPinTap when pin is tapped', (tester) async {
      AudioPinEntity? tappedPin;

      final pins = [
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

      viewModel.currentPagePins.addAll(pins);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 400,
              child: AudioPinOverlay(
                viewModel: viewModel,
                zoom: 1.0,
                onPinTap: (pin) {
                  tappedPin = pin;
                },
                onPinDelete: (pin) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();

      expect(tappedPin?.id, 'pin-1');
    });
  });
}
