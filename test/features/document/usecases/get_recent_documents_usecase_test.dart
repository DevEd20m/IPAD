import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/document/domain/usecases/get_recent_documents_usecase.dart';
import 'package:ipad/features/document/domain/repositories/document_repository.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  late GetRecentDocumentsUseCase useCase;
  late MockDocumentRepository mockRepository;

  setUp(() {
    mockRepository = MockDocumentRepository();
    useCase = GetRecentDocumentsUseCase(mockRepository);
  });

  group('GetRecentDocumentsUseCase', () {
    final testDocuments = [
      DocumentEntity(
        id: 'doc-1',
        name: 'test1.pdf',
        type: 'pdf',
        localPath: '/path/to/test1.pdf',
        createdAt: DateTime(2024, 1, 1),
        lastOpenedAt: DateTime(2024, 1, 2),
        pageCount: 10,
      ),
      DocumentEntity(
        id: 'doc-2',
        name: 'test2.pdf',
        type: 'pdf',
        localPath: '/path/to/test2.pdf',
        createdAt: DateTime(2024, 1, 3),
        lastOpenedAt: DateTime(2024, 1, 4),
        pageCount: 5,
      ),
    ];

    test('should return list of documents', () async {
      when(() => mockRepository.getRecentDocuments())
          .thenAnswer((_) async => testDocuments);

      final result = await useCase();

      expect(result, equals(testDocuments));
      verify(() => mockRepository.getRecentDocuments()).called(1);
    });

    test('should return empty list when no documents', () async {
      when(() => mockRepository.getRecentDocuments())
          .thenAnswer((_) async => []);

      final result = await useCase();

      expect(result, isEmpty);
      verify(() => mockRepository.getRecentDocuments()).called(1);
    });

    test('should throw exception when repository fails', () async {
      when(() => mockRepository.getRecentDocuments())
          .thenThrow(Exception('Failed to load'));

      expect(
        () => useCase(),
        throwsException,
      );
    });
  });
}
