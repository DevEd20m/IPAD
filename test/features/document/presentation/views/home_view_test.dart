import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/document/domain/usecases/import_document_usecase.dart';
import 'package:ipad/features/document/domain/usecases/get_recent_documents_usecase.dart';
import 'package:ipad/features/document/domain/usecases/delete_document_usecase.dart';
import 'package:ipad/features/document/presentation/viewmodels/document_viewmodel.dart';
import 'package:ipad/features/document/presentation/views/home_view.dart';

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
    Get.put<DocumentViewModel>(viewModel);
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeView Widget', () {
    testWidgets('should show loading indicator when loading', (tester) async {
      when(() => mockGetRecentUseCase()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return [];
      });

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomeView(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty state when no documents', (tester) async {
      when(() => mockGetRecentUseCase())
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomeView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No documents yet'), findsOneWidget);
      expect(find.text('Import PDF'), findsOneWidget);
    });

    testWidgets('should show document list when documents exist', (tester) async {
      final documents = [
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

      when(() => mockGetRecentUseCase())
          .thenAnswer((_) async => documents);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomeView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('test.pdf'), findsOneWidget);
    });

    testWidgets('should have settings button in app bar', (tester) async {
      when(() => mockGetRecentUseCase())
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomeView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should have floating action button', (tester) async {
      when(() => mockGetRecentUseCase())
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomeView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
