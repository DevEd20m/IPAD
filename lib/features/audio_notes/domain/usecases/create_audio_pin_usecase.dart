import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/domain/repositories/audio_pin_repository.dart';

class CreateAudioPinUseCase {
  final AudioPinRepository _repository;

  CreateAudioPinUseCase(this._repository);

  Future<AudioPinEntity> call(AudioPinEntity audioPin) async {
    return await _repository.createAudioPin(audioPin);
  }
}
