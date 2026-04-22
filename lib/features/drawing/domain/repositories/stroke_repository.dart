import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';

abstract class StrokeRepository {
  Future<List<StrokeEntity>> getStrokesForPage(String documentId, int pageIndex);
  Future<List<StrokeEntity>> getStrokesForDocument(String documentId);
  Future<void> saveStroke(StrokeEntity stroke);
  Future<void> deleteStroke(String strokeId);
  Future<void> deleteStrokesForPage(String documentId, int pageIndex);
  Future<void> deleteStrokesForDocument(String documentId);
}
