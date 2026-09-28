// Model untuk intake log dari Supabase
class IntakeLogModel {
  final String id;
  final String userId;
  final String medicationId;
  final String scheduledDate;
  final String scheduledTime;
  final String status; // 'taken', 'pending', 'skipped'
  final DateTime? takenAt;
  final DateTime createdAt;

  const IntakeLogModel({
    required this.id,
    required this.userId,
    required this.medicationId,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    this.takenAt,
    required this.createdAt,
  });

  factory IntakeLogModel.fromJson(Map<String, dynamic> json) {
    return IntakeLogModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      medicationId: json['medication_id']?.toString() ?? '',
      scheduledDate: json['scheduled_date']?.toString() ?? '',
      scheduledTime: json['scheduled_time']?.toString() ?? '12:00',
      status: json['status']?.toString() ?? 'pending',
      takenAt: json['taken_at'] != null
          ? DateTime.tryParse(json['taken_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'medication_id': medicationId,
      'scheduled_date': scheduledDate,
      'scheduled_time': scheduledTime,
      'status': status,
      'taken_at': takenAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
