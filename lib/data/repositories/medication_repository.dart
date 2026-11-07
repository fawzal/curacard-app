import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/medication_model.dart';
import '../models/intake_log_model.dart';

class MedicationRepository {
  final SupabaseClient client;

  MedicationRepository({required this.client});

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static final List<MedicationModel> _inMemoryMeds = [];
  static final List<IntakeLogModel> _inMemoryLogs = [];

  // ─────────────────────────────────────────────
  // Fetch all medications for the current user
  // ─────────────────────────────────────────────
  Future<List<MedicationModel>> fetchMedications() async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) {
      return List.unmodifiable(_inMemoryMeds);
    }
    try {
      final response = await client
          .from('medications')
          .select()
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => MedicationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[MedicationRepository] Fallback to in-memory medications: $e');
      return List.unmodifiable(_inMemoryMeds);
    }
  }

  // ─────────────────────────────────────────────
  // Add a new medication and return the saved row
  // ─────────────────────────────────────────────
  Future<MedicationModel> addMedication(MedicationModel med) async {
    final uid = client.auth.currentUser?.id;
    final newMed = MedicationModel(
      id: med.id.isNotEmpty ? med.id : 'med_${DateTime.now().millisecondsSinceEpoch}',
      name: med.name,
      dosage: med.dosage,
      scheduledTimes: med.scheduledTimes,
      iconName: med.iconName,
      useAlarm: med.useAlarm,
    );

    if (uid == null) {
      _inMemoryMeds.add(newMed);
      return newMed;
    }

    try {
      final response = await client.from('medications').insert({
        'user_id': uid,
        'name': med.name,
        'dosage': med.dosage,
        'scheduled_times': med.scheduledTimes,
        'icon_name': med.iconName,
        'use_alarm': med.useAlarm,
      }).select().single();

      return MedicationModel.fromJson(response);
    } catch (e) {
      debugPrint('[MedicationRepository] Fallback to in-memory addMedication: $e');
      _inMemoryMeds.add(newMed);
      return newMed;
    }
  }

  // ─────────────────────────────────────────────
  // Delete a medication by ID
  // ─────────────────────────────────────────────
  Future<void> deleteMedication(String id) async {
    _inMemoryMeds.removeWhere((m) => m.id == id);
    try {
      await client.from('medications').delete().eq('id', id);
    } catch (e) {
      debugPrint('[MedicationRepository] Offline fallback deleteMedication: $e');
    }
  }

  // ─────────────────────────────────────────────
  // Upsert an intake log for today
  // ─────────────────────────────────────────────
  Future<IntakeLogModel> logIntake({
    required String medicationId,
    required String scheduledTime,
    required String status,
  }) async {
    final uid = client.auth.currentUser?.id;
    final now = DateTime.now();
    final fallbackLog = IntakeLogModel(
      id: 'log_${now.millisecondsSinceEpoch}',
      userId: uid ?? 'local_user',
      medicationId: medicationId,
      scheduledDate: _today,
      scheduledTime: scheduledTime,
      status: status,
      takenAt: status == 'taken' ? now : null,
      createdAt: now,
    );

    if (uid == null) {
      _inMemoryLogs.removeWhere((l) =>
          l.medicationId == medicationId && l.scheduledTime == scheduledTime);
      _inMemoryLogs.add(fallbackLog);
      return fallbackLog;
    }

    try {
      final payload = <String, dynamic>{
        'user_id': uid,
        'medication_id': medicationId,
        'scheduled_date': _today,
        'scheduled_time': scheduledTime,
        'status': status,
        'taken_at': status == 'taken' ? DateTime.now().toIso8601String() : null,
      };

      final response = await client
          .from('intake_logs')
          .upsert(
            payload,
            onConflict: 'medication_id,scheduled_date,scheduled_time',
          )
          .select()
          .single();

      return IntakeLogModel.fromJson(response);
    } catch (e) {
      debugPrint('[MedicationRepository] Fallback to in-memory logIntake: $e');
      _inMemoryLogs.removeWhere((l) =>
          l.medicationId == medicationId && l.scheduledTime == scheduledTime);
      _inMemoryLogs.add(fallbackLog);
      return fallbackLog;
    }
  }

  // ─────────────────────────────────────────────
  // Fetch today's intake logs for the current user
  // ─────────────────────────────────────────────
  Future<List<IntakeLogModel>> fetchTodayIntakeLogs() async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) {
      return List.unmodifiable(_inMemoryLogs);
    }
    try {
      final response = await client
          .from('intake_logs')
          .select()
          .eq('scheduled_date', _today)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) =>
              IntakeLogModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[MedicationRepository] Fallback to in-memory intake logs: $e');
      return List.unmodifiable(_inMemoryLogs);
    }
  }
}
