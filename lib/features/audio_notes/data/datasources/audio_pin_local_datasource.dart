import 'package:ipad/core/services/storage_service.dart';
import 'package:ipad/features/audio_notes/data/models/audio_pin_model.dart';

abstract class AudioPinLocalDataSource {
  Future<List<AudioPinModel>> getAudioPinsForPage(String documentId, int pageIndex);
  Future<List<AudioPinModel>> getAudioPinsForDocument(String documentId);
  Future<AudioPinModel> createAudioPin(AudioPinModel audioPin);
  Future<void> deleteAudioPin(String pinId);
  Future<void> deleteAudioPinsForDocument(String documentId);
}

class AudioPinLocalDataSourceImpl implements AudioPinLocalDataSource {
  String _pageKey(String documentId, int pageIndex) => '${documentId}_$pageIndex';

  @override
  Future<List<AudioPinModel>> getAudioPinsForPage(String documentId, int pageIndex) async {
    final box = StorageService.getAudioPinsBox();
    final key = _pageKey(documentId, pageIndex);
    final jsonList = box.get(key, defaultValue: <dynamic>[]) as List;
    return jsonList
        .map((json) => AudioPinModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<AudioPinModel>> getAudioPinsForDocument(String documentId) async {
    final box = StorageService.getAudioPinsBox();
    final allPins = <AudioPinModel>[];
    
    for (final key in box.keys) {
      if (key.toString().startsWith(documentId)) {
        final jsonList = box.get(key, defaultValue: <dynamic>[]) as List;
        allPins.addAll(jsonList.map(
          (json) => AudioPinModel.fromJson(Map<String, dynamic>.from(json)),
        ));
      }
    }
    return allPins;
  }

  @override
  Future<AudioPinModel> createAudioPin(AudioPinModel audioPin) async {
    final box = StorageService.getAudioPinsBox();
    final key = _pageKey(audioPin.documentId, audioPin.pageIndex);
    final jsonList = box.get(key, defaultValue: <dynamic>[]) as List;
    
    final pins = jsonList
        .map((json) => AudioPinModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
    pins.add(audioPin);
    
    await box.put(key, pins.map((p) => p.toJson()).toList());
    return audioPin;
  }

  @override
  Future<void> deleteAudioPin(String pinId) async {
    final box = StorageService.getAudioPinsBox();
    
    for (final key in box.keys) {
      final jsonList = box.get(key, defaultValue: <dynamic>[]) as List;
      final pins = jsonList
          .map((json) => AudioPinModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      
      final filtered = pins.where((p) => p.id != pinId).toList();
      if (filtered.length != pins.length) {
        await box.put(key, filtered.map((p) => p.toJson()).toList());
        break;
      }
    }
  }

  @override
  Future<void> deleteAudioPinsForDocument(String documentId) async {
    final box = StorageService.getAudioPinsBox();
    final keysToDelete = box.keys
        .where((key) => key.toString().startsWith(documentId))
        .toList();
    
    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }
}
