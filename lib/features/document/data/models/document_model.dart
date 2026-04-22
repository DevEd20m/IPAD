import 'package:ipad/features/document/domain/entities/document_entity.dart';

class DocumentModel extends DocumentEntity {
  const DocumentModel({
    required super.id,
    required super.name,
    required super.type,
    required super.localPath,
    required super.createdAt,
    required super.lastOpenedAt,
    super.pageCount,
  });

  factory DocumentModel.fromEntity(DocumentEntity entity) {
    return DocumentModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      localPath: entity.localPath,
      createdAt: entity.createdAt,
      lastOpenedAt: entity.lastOpenedAt,
      pageCount: entity.pageCount,
    );
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      localPath: json['localPath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastOpenedAt: DateTime.parse(json['lastOpenedAt'] as String),
      pageCount: json['pageCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'localPath': localPath,
      'createdAt': createdAt.toIso8601String(),
      'lastOpenedAt': lastOpenedAt.toIso8601String(),
      'pageCount': pageCount,
    };
  }

  DocumentEntity toEntity() {
    return DocumentEntity(
      id: id,
      name: name,
      type: type,
      localPath: localPath,
      createdAt: createdAt,
      lastOpenedAt: lastOpenedAt,
      pageCount: pageCount,
    );
  }
}
