import 'package:ipad/core/services/storage_service.dart';
import 'package:ipad/features/drawing/data/models/stroke_model.dart';

abstract class StrokeLocalDataSource {
  Future<List<StrokeModel>> getStrokesForPage(String documentId, int pageIndex);
  Future<List<StrokeModel>> getStrokesForDocument(String documentId);
  Future<void> saveStroke(StrokeModel stroke);
  Future<void> deleteStroke(String strokeId);
  Future<void> deleteStrokesForPage(String documentId, int pageIndex);
  Future<void> deleteStrokesForDocument(String documentId);
}

class StrokeLocalDataSourceImpl implements StrokeLocalDataSource {
  String _pageKey(String documentId, int pageIndex) => '${documentId}_$pageIndex';

  @override
  Future<List<StrokeModel>> getStrokesForPage(String documentId, int pageIndex) async {
    final box = StorageService.getStrokesBox();
    final key = _pageKey(documentId, pageIndex);
    final jsonList = box.get(key, defaultValue: <dynamic>[]) as List;
    return jsonList
        .map((json) => StrokeModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<StrokeModel>> getStrokesForDocument(String documentId) async {
    final box = StorageService.getStrokesBox();
    final allStrokes = <StrokeModel>[];
    
    for (final key in box.keys) {
      if (key.toString().startsWith(documentId)) {
        final jsonList = box.get(key, defaultValue: <dynamic>[]) as List;
        allStrokes.addAll(jsonList.map(
          (json) => StrokeModel.fromJson(Map<String, dynamic>.from(json)),
        ));
      }
    }
    return allStrokes;
  }

  @override
  Future<void> saveStroke(StrokeModel stroke) async {
    final box = StorageService.getStrokesBox();
    final key = _pageKey(stroke.documentId, stroke.pageIndex);
    final jsonList = box.get(key, defaultValue: <dynamic>[]) as List;
    
    final strokes = jsonList
        .map((json) => StrokeModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
    strokes.add(stroke);
    
    await box.put(key, strokes.map((s) => s.toJson()).toList());
  }

  @override
  Future<void> deleteStroke(String strokeId) async {
    final box = StorageService.getStrokesBox();
    
    for (final key in box.keys) {
      final jsonList = box.get(key, defaultValue: <dynamic>[]) as List;
      final strokes = jsonList
          .map((json) => StrokeModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      
      final filtered = strokes.where((s) => s.id != strokeId).toList();
      if (filtered.length != strokes.length) {
        await box.put(key, filtered.map((s) => s.toJson()).toList());
        break;
      }
    }
  }

  @override
  Future<void> deleteStrokesForPage(String documentId, int pageIndex) async {
    final box = StorageService.getStrokesBox();
    final key = _pageKey(documentId, pageIndex);
    await box.delete(key);
  }

  @override
  Future<void> deleteStrokesForDocument(String documentId) async {
    final box = StorageService.getStrokesBox();
    final keysToDelete = box.keys
        .where((key) => key.toString().startsWith(documentId))
        .toList();
    
    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }
}
