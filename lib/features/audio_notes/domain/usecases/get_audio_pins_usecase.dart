import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/domain/repositories/audio_pin_repository.dart';

class GetAudioPinsUseCase {
  final AudioPinRepository _repository;

  GetAudioPinsUseCase(this._repository);

  Future<List<AudioPinEntity>> call(String documentId, int pageIndex) async {
    return await _repository.getAudioPinsForPage(documentId, pageIndex);
  }
}
