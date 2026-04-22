import 'package:ipad/features/document/data/datasources/document_local_datasource.dart';
import 'package:ipad/features/document/data/models/document_model.dart';
import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/document/domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentLocalDataSource _dataSource;

  DocumentRepositoryImpl(this._dataSource);

  @override
  Future<List<DocumentEntity>> getRecentDocuments() async {
    final models = await _dataSource.getRecentDocuments();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<DocumentEntity?> getDocumentById(String id) async {
    final model = await _dataSource.getDocumentById(id);
    return model?.toEntity();
  }

  @override
  Future<DocumentEntity> importDocument(String filePath) async {
    final model = await _dataSource.importDocument(filePath);
    return model.toEntity();
  }

  @override
  Future<void> updateDocument(DocumentEntity document) async {
    await _dataSource.updateDocument(DocumentModel.fromEntity(document));
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _dataSource.deleteDocument(id);
  }
}
