import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/domain/repositories/stroke_repository.dart';

class GetStrokesUseCase {
  final StrokeRepository _repository;

  GetStrokesUseCase(this._repository);

  Future<List<StrokeEntity>> call(String documentId, int pageIndex) async {
    return await _repository.getStrokesForPage(documentId, pageIndex);
  }
}
