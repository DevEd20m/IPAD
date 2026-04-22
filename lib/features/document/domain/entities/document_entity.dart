class DocumentEntity {
  final String id;
  final String name;
  final String type;
  final String localPath;
  final DateTime createdAt;
  final DateTime lastOpenedAt;
  final int pageCount;

  const DocumentEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.localPath,
    required this.createdAt,
    required this.lastOpenedAt,
    this.pageCount = 0,
  });

  DocumentEntity copyWith({
    String? id,
    String? name,
    String? type,
    String? localPath,
    DateTime? createdAt,
    DateTime? lastOpenedAt,
    int? pageCount,
  }) {
    return DocumentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      localPath: localPath ?? this.localPath,
      createdAt: createdAt ?? this.createdAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      pageCount: pageCount ?? this.pageCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
