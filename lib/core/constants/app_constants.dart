class AppConstants {
  static const String appName = 'PDF Study';
  static const String appVersion = '0.0.1';

  static const int maxRecentDocuments = 10;
  static const int maxAudioRecordingMinutes = 5;
  static const int longPressDurationMs = 500;

  static const double minZoom = 1.0;
  static const double maxZoom = 5.0;
  static const double zoomStep = 0.25;

  static const double minPenWidth = 0.5;
  static const double maxPenWidth = 3.0;
  static const double minPencilWidth = 1.0;
  static const double maxPencilWidth = 5.0;
  static const double minMarkerWidth = 3.0;
  static const double maxMarkerWidth = 15.0;
  static const double minEraserWidth = 5.0;
  static const double maxEraserWidth = 30.0;

  static const double markerOpacity = 0.4;

  static const List<int> defaultColors = [
    0xFF000000, // Black
    0xFF2196F3, // Blue
    0xFFF44336, // Red
    0xFF4CAF50, // Green
    0xFFFFEB3B, // Yellow
    0xFFFF9800, // Orange
    0xFF9C27B0, // Purple
  ];
}
