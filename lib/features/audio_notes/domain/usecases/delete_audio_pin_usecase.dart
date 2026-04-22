import 'package:ipad/features/audio_notes/domain/repositories/audio_pin_repository.dart';

class DeleteAudioPinUseCase {
  final AudioPinRepository _repository;

  DeleteAudioPinUseCase(this._repository);

  Future<void> call(String pinId) async {
    await _repository.deleteAudioPin(pinId);
  }
}
