enum ReadingStatus { notStarted, inProgress, completed }

ReadingStatus statusFromString(String value) {
  switch (value) {
    case 'not_started':
      return ReadingStatus.notStarted;
    case 'in_progress':
      return ReadingStatus.inProgress;
    case 'completed':
      return ReadingStatus.completed;
    default:
      throw ArgumentError('Unknown status: $value');
  }
}

String statusToString(ReadingStatus status) {
  switch (status) {
    case ReadingStatus.notStarted:
      return 'not_started';
    case ReadingStatus.inProgress:
      return 'in_progress';
    case ReadingStatus.completed:
      return 'completed';
  }
}

class Progress {
  final String epubCfi;
  final DateTime lastReadAt;
  final ReadingStatus status;
  final double? percentage;

  Progress({
    required this.epubCfi,
    required this.lastReadAt,
    required this.status,
    this.percentage,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      epubCfi: json['epub_cfi'] ?? '',
      lastReadAt: DateTime.parse(json['last_read_at']),
      status: statusFromString(json['status']),
      percentage: json['percentage']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'epub_cfi': epubCfi,
    'status': statusToString(status),
    'last_read_at': DateTime.now().toIso8601String(),
    'percentage': percentage,
  };
}
