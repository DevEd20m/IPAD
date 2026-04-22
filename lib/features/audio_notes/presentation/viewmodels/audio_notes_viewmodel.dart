import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ipad/core/services/audio_service.dart';
import 'package:ipad/core/utils/helpers.dart';
import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/domain/usecases/create_audio_pin_usecase.dart';
import 'package:ipad/features/audio_notes/domain/usecases/get_audio_pins_usecase.dart';
import 'package:ipad/features/audio_notes/domain/usecases/delete_audio_pin_usecase.dart';

class AudioNotesViewModel extends GetxController {
  final CreateAudioPinUseCase _createAudioPinUseCase = Get.find();
  final GetAudioPinsUseCase _getAudioPinsUseCase = Get.find();
  final DeleteAudioPinUseCase _deleteAudioPinUseCase = Get.find();
  final AudioService _audioService = Get.find();

  final RxList<AudioPinEntity> currentPagePins = <AudioPinEntity>[].obs;
  final RxBool isRecording = false.obs;
  final RxBool isPlaying = false.obs;
  final RxString? playingPinId = RxString('');
  final RxDouble recordingDuration = 0.0.obs;

  String? _currentDocumentId;
  int _currentPageIndex = 0;
  String? _pendingPinPath;
  double? _pendingPinX;
  double? _pendingPinY;

  void setCurrentPage(String documentId, int pageIndex) {
    _currentDocumentId = documentId;
    _currentPageIndex = pageIndex;
    loadPinsForPage();
  }

  Future<void> loadPinsForPage() async {
    if (_currentDocumentId == null) return;
    
    final pins = await _getAudioPinsUseCase(_currentDocumentId!, _currentPageIndex);
    currentPagePins.assignAll(pins);
  }

  Future<bool> hasPermission() async {
    return await _audioService.hasPermission();
  }

  void startCreatingPin(double xNorm, double yNorm) {
    _pendingPinX = xNorm;
    _pendingPinY = yNorm;
  }

  Future<void> startRecording() async {
    if (_pendingPinX == null || _pendingPinY == null) return;

    final path = await _audioService.startRecording();
    if (path != null) {
      _pendingPinPath = path;
      isRecording.value = true;
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    final path = await _audioService.stopRecording();
    if (path != null && _currentDocumentId != null) {
      final duration = await _audioService.getAudioDuration(path) ?? Duration.zero;
      
      final audioPin = AudioPinEntity(
        id: IdGenerator.generate(),
        documentId: _currentDocumentId!,
        pageIndex: _currentPageIndex,
        xNorm: _pendingPinX!,
        yNorm: _pendingPinY!,
        audioPath: path,
        duration: duration,
        createdAt: DateTime.now(),
      );

      await _createAudioPinUseCase(audioPin);
      currentPagePins.add(audioPin);
    }

    isRecording.value = false;
    _pendingPinPath = null;
    _pendingPinX = null;
    _pendingPinY = null;
  }

  Future<void> cancelRecording() async {
    await _audioService.cancelRecording();
    isRecording.value = false;
    _pendingPinPath = null;
    _pendingPinX = null;
    _pendingPinY = null;
  }

  Future<void> playAudio(AudioPinEntity pin) async {
    if (isPlaying.value) {
      await stopPlayback();
    }
    
    await _audioService.playAudio(pin.audioPath);
    isPlaying.value = true;
    playingPinId?.value = pin.id;

    _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        playingPinId?.value = '';
      }
    });
  }

  Future<void> stopPlayback() async {
    await _audioService.stopPlayback();
    isPlaying.value = false;
    playingPinId?.value = '';
  }

  Future<void> deletePin(AudioPinEntity pin) async {
    await _audioService.deleteAudioFile(pin.audioPath);
    await _deleteAudioPinUseCase(pin.id);
    currentPagePins.removeWhere((p) => p.id == pin.id);
  }

  @override
  void onClose() {
    _audioService.dispose();
    super.onClose();
  }
}
