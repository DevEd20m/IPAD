import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/domain/repositories/stroke_repository.dart';

class SaveStrokeUseCase {
  final StrokeRepository _repository;

  SaveStrokeUseCase(this._repository);

  Future<void> call(StrokeEntity stroke) async {
    await _repository.saveStroke(stroke);
  }
}
