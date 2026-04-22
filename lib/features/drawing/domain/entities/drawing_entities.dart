enum DrawingToolType {
  pen,
  pencil,
  marker,
  eraser,
}

class DrawingTool {
  final DrawingToolType type;
  final int color;
  final double width;
  final double opacity;

  const DrawingTool({
    required this.type,
    required this.color,
    required this.width,
    this.opacity = 1.0,
  });

  DrawingTool copyWith({
    DrawingToolType? type,
    int? color,
    double? width,
    double? opacity,
  }) {
    return DrawingTool(
      type: type ?? this.type,
      color: color ?? this.color,
      width: width ?? this.width,
      opacity: opacity ?? this.opacity,
    );
  }

  static const DrawingTool defaultPen = DrawingTool(
    type: DrawingToolType.pen,
    color: 0xFF000000,
    width: 1.5,
  );
}

class DrawingPoint {
  final double x;
  final double y;
  final double pressure;

  const DrawingPoint({
    required this.x,
    required this.y,
    this.pressure = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'pressure': pressure,
      };

  factory DrawingPoint.fromJson(Map<String, dynamic> json) => DrawingPoint(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        pressure: (json['pressure'] as num?)?.toDouble() ?? 1.0,
      );
}

class StrokeEntity {
  final String id;
  final String documentId;
  final int pageIndex;
  final DrawingToolType toolType;
  final int color;
  final double width;
  final double opacity;
  final List<DrawingPoint> points;
  final DateTime createdAt;

  const StrokeEntity({
    required this.id,
    required this.documentId,
    required this.pageIndex,
    required this.toolType,
    required this.color,
    required this.width,
    required this.opacity,
    required this.points,
    required this.createdAt,
  });

  StrokeEntity copyWith({
    String? id,
    String? documentId,
    int? pageIndex,
    DrawingToolType? toolType,
    int? color,
    double? width,
    double? opacity,
    List<DrawingPoint>? points,
    DateTime? createdAt,
  }) {
    return StrokeEntity(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      pageIndex: pageIndex ?? this.pageIndex,
      toolType: toolType ?? this.toolType,
      color: color ?? this.color,
      width: width ?? this.width,
      opacity: opacity ?? this.opacity,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
