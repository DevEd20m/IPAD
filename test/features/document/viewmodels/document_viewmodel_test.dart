import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/document/domain/usecases/import_document_usecase.dart';
import 'package:ipad/features/document/domain/usecases/get_recent_documents_usecase.dart';
import 'package:ipad/features/document/domain/usecases/delete_document_usecase.dart';
import 'package:ipad/features/document/presentation/viewmodels/document_viewmodel.dart';

class MockImportDocumentUseCase extends Mock implements ImportDocumentUseCase {}
class MockGetRecentDocumentsUseCase extends Mock implements GetRecentDocumentsUseCase {}
class MockDeleteDocumentUseCase extends Mock implements DeleteDocumentUseCase {}

void main() {
  late DocumentViewModel viewModel;
  late MockImportDocumentUseCase mockImportUseCase;
  late MockGetRecentDocumentsUseCase mockGetRecentUseCase;
  late MockDeleteDocumentUseCase mockDeleteUseCase;

  setUp(() {
    Get.testMode = true;
    mockImportUseCase = MockImportDocumentUseCase();
    mockGetRecentUseCase = MockGetRecentDocumentsUseCase();
    mockDeleteUseCase = MockDeleteDocumentUseCase();

    Get.put<ImportDocumentUseCase>(mockImportUseCase);
    Get.put<GetRecentDocumentsUseCase>(mockGetRecentUseCase);
    Get.put<DeleteDocumentUseCase>(mockDeleteUseCase);

    viewModel = DocumentViewModel();
  });

  tearDown(() {
    Get.reset();
  });

  setUpAll(() {
    registerFallbackValue(DocumentEntity(
      id: 'test-id',
      name: 'test.pdf',
      type: 'pdf',
      localPath: '/path/to/test.pdf',
      createdAt: DateTime.now(),
      lastOpenedAt: DateTime.now(),
    ));
  });

  group('DocumentViewModel', () {
    final testDocuments = [
      DocumentEntity(
        id: 'doc-1',
        name: 'test.pdf',
        type: 'pdf',
        localPath: '/path/to/test.pdf',
        createdAt: DateTime(2024, 1, 1),
        lastOpenedAt: DateTime(2024, 1, 1),
        pageCount: 10,
      ),
    ];

    test('should load documents on init', () async {
      when(() => mockGetRecentUseCase())
          .thenAnswer((_) async => testDocuments);

      viewModel.onInit();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.documents.length, 1);
      expect(viewModel.documents.first.id, 'doc-1');
    });

    test('should set isLoading during load', () async {
      when(() => mockGetRecentUseCase())
          .thenAnswer((_) async => testDocuments);

      viewModel.onInit();
      
      expect(viewModel.isLoading.value, true);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(viewModel.isLoading.value, false);
    });

    test('should import document successfully', () async {
      when(() => mockImportUseCase(any()))
          .thenAnswer((_) async => testDocuments.first);

      final result = await viewModel.importDocument('/path/to/test.pdf');

      expect(result, isNotNull);
      expect(viewModel.documents.length, 1);
    });

    test('should delete document successfully', () async {
      when(() => mockGetRecentUseCase())
          .thenAnswer((_) async => testDocuments);
      when(() => mockDeleteUseCase(any()))
          .thenAnswer((_) async {});

      viewModel.onInit();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.deleteDocument('doc-1');

      expect(viewModel.documents, isEmpty);
    });

    test('should handle import error', () async {
      when(() => mockImportUseCase(any()))
          .thenThrow(Exception('Import failed'));

      final result = await viewModel.importDocument('/path/to/test.pdf');

      expect(result, isNull);
      expect(viewModel.errorMessage.value, contains('Error importing'));
    });

    test('should handle delete error', () async {
      when(() => mockGetRecentUseCase())
          .thenAnswer((_) async => testDocuments);
      when(() => mockDeleteUseCase(any()))
          .thenThrow(Exception('Delete failed'));

      viewModel.onInit();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.deleteDocument('doc-1');

      expect(viewModel.errorMessage.value, contains('Error deleting'));
    });
  });
}
