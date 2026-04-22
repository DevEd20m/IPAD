class AudioPinEntity {
  final String id;
  final String documentId;
  final int pageIndex;
  final double xNorm;
  final double yNorm;
  final String audioPath;
  final Duration duration;
  final DateTime createdAt;

  const AudioPinEntity({
    required this.id,
    required this.documentId,
    required this.pageIndex,
    required this.xNorm,
    required this.yNorm,
    required this.audioPath,
    required this.duration,
    required this.createdAt,
  });

  AudioPinEntity copyWith({
    String? id,
    String? documentId,
    int? pageIndex,
    double? xNorm,
    double? yNorm,
    String? audioPath,
    Duration? duration,
    DateTime? createdAt,
  }) {
    return AudioPinEntity(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      pageIndex: pageIndex ?? this.pageIndex,
      xNorm: xNorm ?? this.xNorm,
      yNorm: yNorm ?? this.yNorm,
      audioPath: audioPath ?? this.audioPath,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioPinEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
