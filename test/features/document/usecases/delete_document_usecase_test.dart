import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipad/features/document/domain/usecases/delete_document_usecase.dart';
import 'package:ipad/features/document/domain/repositories/document_repository.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  late DeleteDocumentUseCase useCase;
  late MockDocumentRepository mockRepository;

  setUp(() {
    mockRepository = MockDocumentRepository();
    useCase = DeleteDocumentUseCase(mockRepository);
  });

  group('DeleteDocumentUseCase', () {
    test('should call repository deleteDocument', () async {
      when(() => mockRepository.deleteDocument(any()))
          .thenAnswer((_) async {});

      await useCase('doc-1');

      verify(() => mockRepository.deleteDocument('doc-1')).called(1);
    });

    test('should throw exception when deletion fails', () async {
      when(() => mockRepository.deleteDocument(any()))
          .thenThrow(Exception('Delete failed'));

      expect(
        () => useCase('doc-1'),
        throwsException,
      );
    });
  });
}
