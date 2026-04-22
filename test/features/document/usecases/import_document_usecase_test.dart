import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/document/domain/usecases/import_document_usecase.dart';
import 'package:ipad/features/document/domain/repositories/document_repository.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  late ImportDocumentUseCase useCase;
  late MockDocumentRepository mockRepository;

  setUp(() {
    mockRepository = MockDocumentRepository();
    useCase = ImportDocumentUseCase(mockRepository);
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

  group('ImportDocumentUseCase', () {
    final testDocument = DocumentEntity(
      id: 'doc-1',
      name: 'test.pdf',
      type: 'pdf',
      localPath: '/path/to/test.pdf',
      createdAt: DateTime(2024, 1, 1),
      lastOpenedAt: DateTime(2024, 1, 1),
      pageCount: 10,
    );

    test('should return document when import is successful', () async {
      when(() => mockRepository.importDocument(any()))
          .thenAnswer((_) async => testDocument);

      final result = await useCase('/path/to/test.pdf');

      expect(result, equals(testDocument));
      verify(() => mockRepository.importDocument('/path/to/test.pdf')).called(1);
    });

    test('should throw exception when import fails', () async {
      when(() => mockRepository.importDocument(any()))
          .thenThrow(Exception('Import failed'));

      expect(
        () => useCase('/path/to/test.pdf'),
        throwsException,
      );
    });
  });
}
