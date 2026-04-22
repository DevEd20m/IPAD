import 'package:get/get.dart';
import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/document/domain/usecases/import_document_usecase.dart';
import 'package:ipad/features/document/domain/usecases/get_recent_documents_usecase.dart';
import 'package:ipad/features/document/domain/usecases/delete_document_usecase.dart';

class DocumentViewModel extends GetxController {
  final ImportDocumentUseCase _importDocumentUseCase = Get.find();
  final GetRecentDocumentsUseCase _getRecentDocumentsUseCase = Get.find();
  final DeleteDocumentUseCase _deleteDocumentUseCase = Get.find();

  final RxList<DocumentEntity> documents = <DocumentEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentDocuments();
  }

  Future<void> loadRecentDocuments() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getRecentDocumentsUseCase();
      documents.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Error loading documents: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<DocumentEntity?> importDocument(String filePath) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final document = await _importDocumentUseCase(filePath);
      documents.insert(0, document);
      return document;
    } catch (e) {
      errorMessage.value = 'Error importing document: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDocument(String documentId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _deleteDocumentUseCase(documentId);
      documents.removeWhere((doc) => doc.id == documentId);
    } catch (e) {
      errorMessage.value = 'Error deleting document: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLastOpened(DocumentEntity document) async {
    final updated = document.copyWith(lastOpenedAt: DateTime.now());
    final index = documents.indexWhere((d) => d.id == document.id);
    if (index != -1) {
      documents[index] = updated;
    }
  }

  @override
  void onClose() {
    documents.clear();
    super.onClose();
  }
}
