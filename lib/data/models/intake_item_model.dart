import '../../core/utils/adherence_calculator.dart';
import 'medication_model.dart';

/// Membungkus MedicationModel dan jam spesifik (jadwal minum).
/// Jika satu obat dijadwalkan 3x sehari, akan ada 3 IntakeItemModel.
class IntakeItemModel {
  final MedicationModel medication;
  final String scheduledTime;
  final IntakeStatus status;
  final DateTime? takenAt;

  const IntakeItemModel({
    required this.medication,
    required this.scheduledTime,
    this.status = IntakeStatus.pending,
    this.takenAt,
  });

  IntakeItemModel copyWith({
    MedicationModel? medication,
    String? scheduledTime,
    IntakeStatus? status,
    DateTime? takenAt,
  }) {
    return IntakeItemModel(
      medication: medication ?? this.medication,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      takenAt: takenAt ?? this.takenAt,
    );
  }
}
