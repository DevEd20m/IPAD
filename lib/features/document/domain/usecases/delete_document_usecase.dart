import 'package:ipad/features/document/domain/repositories/document_repository.dart';

class DeleteDocumentUseCase {
  final DocumentRepository _repository;

  DeleteDocumentUseCase(this._repository);

  Future<void> call(String documentId) async {
    await _repository.deleteDocument(documentId);
  }
}
