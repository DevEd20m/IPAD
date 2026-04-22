import 'package:ipad/features/document/domain/entities/document_entity.dart';

abstract class DocumentRepository {
  Future<List<DocumentEntity>> getRecentDocuments();
  Future<DocumentEntity?> getDocumentById(String id);
  Future<DocumentEntity> importDocument(String filePath);
  Future<void> updateDocument(DocumentEntity document);
  Future<void> deleteDocument(String id);
}
