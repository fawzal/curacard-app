import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/supabase_config.dart';
import '../../core/utils/adherence_calculator.dart';
import '../../data/models/medication_model.dart';
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
    extends StateNotifier<AsyncValue<List<MedicationModel>>> {
  final MedicationRepository _repository;

  MedicationNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadMedications();
  }

  Future<void> loadMedications() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.fetchMedications();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMedication(MedicationModel med) async {
    try {
      final saved = await _repository.addMedication(med);
      final current = state.value ?? [];
      state = AsyncValue.data([...current, saved]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      await _repository.deleteMedication(id);
      final current = state.value ?? [];
      state = AsyncValue.data(
        current.where((m) => m.id != id).toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleStatus(String medicationId) async {
    final current = state.value;
    if (current == null) return;

    final target = current.firstWhere((m) => m.id == medicationId);
    final newStatus = target.status == IntakeStatus.taken
        ? IntakeStatus.pending
        : IntakeStatus.taken;

    try {
      await _repository.logIntake(
        medicationId: medicationId,
        status: newStatus.name,
      );

      final updated = current.map((m) {
        if (m.id != medicationId) return m;
        return m.copyWith(
          status: newStatus,
          takenAt:
              newStatus == IntakeStatus.taken ? DateTime.now() : null,
        );
      }).toList();

      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ─────────────────────────────────────────────
// Notifier provider
// ─────────────────────────────────────────────
final medicationNotifierProvider = StateNotifierProvider<MedicationNotifier,
    AsyncValue<List<MedicationModel>>>((ref) {
  return MedicationNotifier(ref.watch(medicationRepositoryProvider));
});

// ─────────────────────────────────────────────
// Derived: adherence score
// ─────────────────────────────────────────────
final adherenceScoreProvider = Provider<double>((ref) {
  return ref.watch(medicationNotifierProvider).maybeWhen(
        data: (meds) =>
            AdherenceCalculator.calculateScore(
              meds.map((m) => m.status).toList(),
            ),
        orElse: () => 100.0,
      );
});
