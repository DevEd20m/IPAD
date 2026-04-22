import 'package:ipad/features/drawing/data/datasources/stroke_local_datasource.dart';
import 'package:ipad/features/drawing/data/models/stroke_model.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/domain/repositories/stroke_repository.dart';

class StrokeRepositoryImpl implements StrokeRepository {
  final StrokeLocalDataSource _dataSource;

  StrokeRepositoryImpl(this._dataSource);

  @override
  Future<List<StrokeEntity>> getStrokesForPage(String documentId, int pageIndex) async {
    final models = await _dataSource.getStrokesForPage(documentId, pageIndex);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<StrokeEntity>> getStrokesForDocument(String documentId) async {
    final models = await _dataSource.getStrokesForDocument(documentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveStroke(StrokeEntity stroke) async {
    await _dataSource.saveStroke(StrokeModel.fromEntity(stroke));
  }

  @override
  Future<void> deleteStroke(String strokeId) async {
    await _dataSource.deleteStroke(strokeId);
  }

  @override
  Future<void> deleteStrokesForPage(String documentId, int pageIndex) async {
    await _dataSource.deleteStrokesForPage(documentId, pageIndex);
  }

  @override
  Future<void> deleteStrokesForDocument(String documentId) async {
    await _dataSource.deleteStrokesForDocument(documentId);
  }
}
