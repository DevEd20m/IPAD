import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/document/domain/repositories/document_repository.dart';

class ImportDocumentUseCase {
  final DocumentRepository _repository;

  ImportDocumentUseCase(this._repository);

  Future<DocumentEntity> call(String filePath) async {
    return await _repository.importDocument(filePath);
  }
}
