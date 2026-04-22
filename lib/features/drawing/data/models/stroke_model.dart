import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';

class StrokeModel extends StrokeEntity {
  const StrokeModel({
    required super.id,
    required super.documentId,
    required super.pageIndex,
    required super.toolType,
    required super.color,
    required super.width,
    required super.opacity,
    required super.points,
    required super.createdAt,
  });

  factory StrokeModel.fromEntity(StrokeEntity entity) {
    return StrokeModel(
      id: entity.id,
      documentId: entity.documentId,
      pageIndex: entity.pageIndex,
      toolType: entity.toolType,
      color: entity.color,
      width: entity.width,
      opacity: entity.opacity,
      points: entity.points,
      createdAt: entity.createdAt,
    );
  }

  factory StrokeModel.fromJson(Map<String, dynamic> json) {
    return StrokeModel(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      pageIndex: json['pageIndex'] as int,
      toolType: DrawingToolType.values.firstWhere(
        (e) => e.name == json['toolType'],
        orElse: () => DrawingToolType.pen,
      ),
      color: json['color'] as int,
      width: (json['width'] as num).toDouble(),
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      points: (json['points'] as List<dynamic>)
          .map((p) => DrawingPoint.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'pageIndex': pageIndex,
      'toolType': toolType.name,
      'color': color,
      'width': width,
      'opacity': opacity,
      'points': points.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  StrokeEntity toEntity() {
    return StrokeEntity(
      id: id,
      documentId: documentId,
      pageIndex: pageIndex,
      toolType: toolType,
      color: color,
      width: width,
      opacity: opacity,
      points: points,
      createdAt: createdAt,
    );
  }
}
