import 'package:ipad/features/drawing/domain/repositories/stroke_repository.dart';

class DeleteStrokeUseCase {
  final StrokeRepository _repository;

  DeleteStrokeUseCase(this._repository);

  Future<void> call(String strokeId) async {
    await _repository.deleteStroke(strokeId);
  }
}
