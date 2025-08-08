class DetectionHistory {
  final String id;
  final String userId;
  final DateTime detectedAt;
  final String prediction;
  final double confidence;
  final String? filename;

  DetectionHistory({
    required this.id,
    required this.userId,
    required this.detectedAt,
    required this.prediction,
    required this.confidence,
    this.filename,
  });

  factory DetectionHistory.fromJson(Map<String, dynamic> json) {
    return DetectionHistory(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      detectedAt: DateTime.parse(json['detected_at']),
      prediction: json['prediction'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      filename: json['filename'],
    );
  }
} 