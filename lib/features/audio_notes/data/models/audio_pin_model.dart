import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';

class AudioPinModel extends AudioPinEntity {
  const AudioPinModel({
    required super.id,
    required super.documentId,
    required super.pageIndex,
    required super.xNorm,
    required super.yNorm,
    required super.audioPath,
    required super.duration,
    required super.createdAt,
  });

  factory AudioPinModel.fromEntity(AudioPinEntity entity) {
    return AudioPinModel(
      id: entity.id,
      documentId: entity.documentId,
      pageIndex: entity.pageIndex,
      xNorm: entity.xNorm,
      yNorm: entity.yNorm,
      audioPath: entity.audioPath,
      duration: entity.duration,
      createdAt: entity.createdAt,
    );
  }

  factory AudioPinModel.fromJson(Map<String, dynamic> json) {
    return AudioPinModel(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      pageIndex: json['pageIndex'] as int,
      xNorm: (json['xNorm'] as num).toDouble(),
      yNorm: (json['yNorm'] as num).toDouble(),
      audioPath: json['audioPath'] as String,
      duration: Duration(milliseconds: json['durationMs'] as int),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'pageIndex': pageIndex,
      'xNorm': xNorm,
      'yNorm': yNorm,
      'audioPath': audioPath,
      'durationMs': duration.inMilliseconds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AudioPinEntity toEntity() {
    return AudioPinEntity(
      id: id,
      documentId: documentId,
      pageIndex: pageIndex,
      xNorm: xNorm,
      yNorm: yNorm,
      audioPath: audioPath,
      duration: duration,
      createdAt: createdAt,
    );
  }
}
