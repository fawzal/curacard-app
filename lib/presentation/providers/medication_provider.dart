import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/supabase_config.dart';
import '../../core/utils/adherence_calculator.dart';
import '../../core/services/notification_service.dart';
import '../../data/models/medication_model.dart';
import '../../data/models/intake_item_model.dart';
import '../../data/repositories/medication_repository.dart';

// ─────────────────────────────────────────────
// Repository provider
// ─────────────────────────────────────────────
final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepository(client: SupabaseConfig.client);
});

// ─────────────────────────────────────────────
// StateNotifier
// ─────────────────────────────────────────────
class MedicationNotifier
    extends StateNotifier<AsyncValue<List<IntakeItemModel>>> {
  final MedicationRepository _repository;

  MedicationNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadMedications();
  }

  Future<void> loadMedications() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.fetchMedications();
      final todayLogs = await _repository.fetchTodayIntakeLogs();

      // Expand each MedicationModel into multiple IntakeItemModels based on scheduledTimes
      final List<IntakeItemModel> intakeItems = [];

      for (var med in list) {
        for (var time in med.scheduledTimes) {
          final log = todayLogs.where((l) => l.medicationId == med.id && l.scheduledTime == time).firstOrNull;
          
          IntakeStatus intakeStatus = IntakeStatus.pending;
          DateTime? takenAt;

          if (log != null) {
            takenAt = log.takenAt;
            switch (log.status) {
              case 'taken':
                intakeStatus = IntakeStatus.taken;
                break;
              case 'skipped':
                intakeStatus = IntakeStatus.skipped;
                break;
            }
          }

          intakeItems.add(IntakeItemModel(
            medication: med,
            scheduledTime: time,
            status: intakeStatus,
            takenAt: takenAt,
          ));
        }
      }

      // Optional: Sort by time
      intakeItems.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

      state = AsyncValue.data(intakeItems);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  int _generateNotificationId(String medicationId, String time) {
    // Deterministic djb2 hash to ensure consistency across app restarts
    String input = medicationId + time;
    int hash = 5381;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) + hash) + input.codeUnitAt(i);
    }
    // Mask to 32-bit positive integer (required by Android)
    return hash & 0x7FFFFFFF;
  }

  Future<void> addMedication(MedicationModel med) async {
    try {
      final saved = await _repository.addMedication(med);
      final current = state.value ?? [];
      
      final List<IntakeItemModel> newItems = saved.scheduledTimes.map((time) {
        // Schedule notification for each time
        final notifId = _generateNotificationId(saved.id, time);
        NotificationService().scheduleMedicationReminder(
          id: notifId,
          medicationName: saved.name,
          dosage: saved.dosage,
          scheduledTime: time,
          useAlarm: saved.useAlarm,
        );

        return IntakeItemModel(
          medication: saved,
          scheduledTime: time,
        );
      }).toList();

      final updated = [...current, ...newItems];
      updated.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
      
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      final current = state.value ?? [];
      
      // Cancel alarms before deleting
      final targetItems = current.where((m) => m.medication.id == id);
      for (var item in targetItems) {
        final notifId = _generateNotificationId(id, item.scheduledTime);
        NotificationService().cancelNotification(notifId);
      }

      await _repository.deleteMedication(id);
      
      state = AsyncValue.data(
        current.where((m) => m.medication.id != id).toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleStatus(String medicationId, String scheduledTime) async {
    final current = state.value;
    if (current == null) return;

    final target = current.firstWhere(
      (m) => m.medication.id == medicationId && m.scheduledTime == scheduledTime,
    );
    
    final newStatus = target.status == IntakeStatus.taken
        ? IntakeStatus.pending
        : IntakeStatus.taken;

    try {
      // Optimistic update
      final updatedOptimistic = current.map((m) {
        if (m.medication.id != medicationId || m.scheduledTime != scheduledTime) return m;
        return m.copyWith(
          status: newStatus,
          takenAt: newStatus == IntakeStatus.taken ? DateTime.now() : null,
        );
      }).toList();
      state = AsyncValue.data(updatedOptimistic);

      await _repository.logIntake(
        medicationId: medicationId,
        scheduledTime: scheduledTime,
        status: newStatus.name,
      );

    } catch (e, st) {
      // If error, reload
      loadMedications();
      state = AsyncValue.error(e, st);
    }
  }
}

// ─────────────────────────────────────────────
// Notifier provider
// ─────────────────────────────────────────────
final medicationNotifierProvider = StateNotifierProvider<MedicationNotifier,
    AsyncValue<List<IntakeItemModel>>>((ref) {
  return MedicationNotifier(ref.watch(medicationRepositoryProvider));
});

// ─────────────────────────────────────────────
// Derived: adherence score
// ─────────────────────────────────────────────
final adherenceScoreProvider = Provider<double>((ref) {
  return ref.watch(medicationNotifierProvider).maybeWhen(
        data: (items) =>
            AdherenceCalculator.calculateScore(
              items.map((m) => m.status).toList(),
            ),
        orElse: () => 100.0,
      );
});
