import 'package:ipad/features/audio_notes/data/datasources/audio_pin_local_datasource.dart';
import 'package:ipad/features/audio_notes/data/models/audio_pin_model.dart';
import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/domain/repositories/audio_pin_repository.dart';

class AudioPinRepositoryImpl implements AudioPinRepository {
  final AudioPinLocalDataSource _dataSource;

  AudioPinRepositoryImpl(this._dataSource);

  @override
  Future<List<AudioPinEntity>> getAudioPinsForPage(String documentId, int pageIndex) async {
    final models = await _dataSource.getAudioPinsForPage(documentId, pageIndex);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AudioPinEntity>> getAudioPinsForDocument(String documentId) async {
    final models = await _dataSource.getAudioPinsForDocument(documentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AudioPinEntity> createAudioPin(AudioPinEntity audioPin) async {
    final model = await _dataSource.createAudioPin(AudioPinModel.fromEntity(audioPin));
    return model.toEntity();
  }

  @override
  Future<void> deleteAudioPin(String pinId) async {
    await _dataSource.deleteAudioPin(pinId);
  }

  @override
  Future<void> deleteAudioPinsForDocument(String documentId) async {
    await _dataSource.deleteAudioPinsForDocument(documentId);
  }
}
