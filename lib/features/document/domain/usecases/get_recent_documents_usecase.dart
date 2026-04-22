import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/document/domain/repositories/document_repository.dart';

class GetRecentDocumentsUseCase {
  final DocumentRepository _repository;

  GetRecentDocumentsUseCase(this._repository);

  Future<List<DocumentEntity>> call() async {
    return await _repository.getRecentDocuments();
  }
}
