import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';

abstract class AudioPinRepository {
  Future<List<AudioPinEntity>> getAudioPinsForPage(String documentId, int pageIndex);
  Future<List<AudioPinEntity>> getAudioPinsForDocument(String documentId);
  Future<AudioPinEntity> createAudioPin(AudioPinEntity audioPin);
  Future<void> deleteAudioPin(String pinId);
  Future<void> deleteAudioPinsForDocument(String documentId);
}
