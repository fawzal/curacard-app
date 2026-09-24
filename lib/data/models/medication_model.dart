import '../../core/utils/adherence_calculator.dart';

class MedicationModel {
  final String id;
  final String name;
  final String dosage;
  final String scheduledTime;
  final String iconName;
  final IntakeStatus status;
  final DateTime? takenAt;

  const MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.scheduledTime,
    this.iconName = 'pill',
    this.status = IntakeStatus.pending,
    this.takenAt,
  });

  static List<MedicationModel> getInitialSampleList() {
    return [
      MedicationModel(
        id: '11111111-1111-1111-1111-111111111111',
        name: 'Amlodipine Besylate',
        dosage: '5 mg - 1 Pill',
        scheduledTime: '08:00 AM',
        iconName: 'pill',
        status: IntakeStatus.taken,
        takenAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      MedicationModel(
        id: '22222222-2222-2222-2222-222222222222',
        name: 'Salbutamol Inhaler',
        dosage: '2 Puffs (As Needed)',
        scheduledTime: '12:00 PM',
        iconName: 'inhaler',
        status: IntakeStatus.pending,
      ),
      MedicationModel(
        id: '33333333-3333-3333-3333-333333333333',
        name: 'Multivitamin Complex',
        dosage: '1 Tablet',
        scheduledTime: '07:00 PM',
        iconName: 'tablet',
        status: IntakeStatus.pending,
      ),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'scheduled_time': scheduledTime,
      'icon_name': iconName,
      'status': status.name,
      'taken_at': takenAt?.toIso8601String(),
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    IntakeStatus parseStatus(String? val) {
      if (val == 'taken') return IntakeStatus.taken;
      if (val == 'skipped') return IntakeStatus.skipped;
      return IntakeStatus.pending;
    }

    return MedicationModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Medication',
      dosage: map['dosage']?.toString() ?? '1 Dose',
      scheduledTime: map['scheduled_time']?.toString() ?? '08:00',
      iconName: map['icon_name']?.toString() ?? 'pill',
      status: parseStatus(map['status']?.toString()),
      takenAt: map['taken_at'] != null 
          ? DateTime.tryParse(map['taken_at'].toString()) 
          : null,
    );
  }

  /// Alias for Supabase JSON compatibility
  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      MedicationModel.fromMap(json);

  MedicationModel copyWith({
    String? id,
    String? name,
    String? dosage,
    String? scheduledTime,
    String? iconName,
    IntakeStatus? status,
    DateTime? takenAt,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      iconName: iconName ?? this.iconName,
      status: status ?? this.status,
      takenAt: takenAt ?? this.takenAt,
    );
  }
}
