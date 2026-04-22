import 'dart:io';
import 'package:ipad/core/services/storage_service.dart';
import 'package:ipad/core/utils/helpers.dart';
import 'package:ipad/features/document/data/models/document_model.dart';

abstract class DocumentLocalDataSource {
  Future<List<DocumentModel>> getRecentDocuments();
  Future<DocumentModel?> getDocumentById(String id);
  Future<DocumentModel> importDocument(String filePath);
  Future<void> updateDocument(DocumentModel document);
  Future<void> deleteDocument(String id);
}

class DocumentLocalDataSourceImpl implements DocumentLocalDataSource {
  @override
  Future<List<DocumentModel>> getRecentDocuments() async {
    final box = StorageService.getDocumentsBox();
    final documents = box.values
        .map((json) => DocumentModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
    documents.sort((a, b) => b.lastOpenedAt.compareTo(a.lastOpenedAt));
    return documents.take(10).toList();
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    final box = StorageService.getDocumentsBox();
    final json = box.get(id);
    if (json == null) return null;
    return DocumentModel.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<DocumentModel> importDocument(String filePath) async {
    final file = File(filePath);
    final fileName = filePath.split('/').last;
    final id = IdGenerator.generate();
    final now = DateTime.now();

    final document = DocumentModel(
      id: id,
      name: fileName,
      type: 'pdf',
      localPath: filePath,
      createdAt: now,
      lastOpenedAt: now,
      pageCount: 0,
    );

    final box = StorageService.getDocumentsBox();
    await box.put(id, document.toJson());
    return document;
  }

  @override
  Future<void> updateDocument(DocumentModel document) async {
    final box = StorageService.getDocumentsBox();
    await box.put(document.id, document.toJson());
  }

  @override
  Future<void> deleteDocument(String id) async {
    final box = StorageService.getDocumentsBox();
    await box.delete(id);
  }
}
