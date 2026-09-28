import '../../core/utils/adherence_calculator.dart';

class MedicationModel {
  final String id;
  final String name;
  final String dosage;
  final List<String> scheduledTimes;
  final String iconName;
  final bool useAlarm;

  const MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.scheduledTimes,
    this.iconName = 'pill',
    this.useAlarm = false,
  });

  static List<MedicationModel> getInitialSampleList() {
    return [
      MedicationModel(
        id: '11111111-1111-1111-1111-111111111111',
        name: 'Amlodipine Besylate',
        dosage: '5 mg - 1 Pill',
        scheduledTimes: ['08:00 AM'],
        iconName: 'pill',
        useAlarm: false,
      ),
      MedicationModel(
        id: '22222222-2222-2222-2222-222222222222',
        name: 'Salbutamol Inhaler',
        dosage: '2 Puffs (As Needed)',
        scheduledTimes: ['12:00 PM'],
        iconName: 'inhaler',
        useAlarm: true,
      ),
      MedicationModel(
        id: '33333333-3333-3333-3333-333333333333',
        name: 'Multivitamin Complex',
        dosage: '1 Tablet',
        scheduledTimes: ['07:00 PM', '07:00 AM'],
        iconName: 'tablet',
        useAlarm: false,
      ),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'scheduled_times': scheduledTimes,
      'icon_name': iconName,
      'use_alarm': useAlarm,
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Medication',
      dosage: map['dosage']?.toString() ?? '1 Dose',
      scheduledTimes: List<String>.from(map['scheduled_times'] ?? ['08:00']),
      iconName: map['icon_name']?.toString() ?? 'pill',
      useAlarm: map['use_alarm'] == true,
    );
  }

  /// Alias for Supabase JSON compatibility
  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      MedicationModel.fromMap(json);

  MedicationModel copyWith({
    String? id,
    String? name,
    String? dosage,
    List<String>? scheduledTimes,
    String? iconName,
    bool? useAlarm,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      iconName: iconName ?? this.iconName,
      useAlarm: useAlarm ?? this.useAlarm,
    );
  }
}
