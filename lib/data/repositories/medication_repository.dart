import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/medication_model.dart';
import '../models/intake_log_model.dart';

class MedicationRepository {
  final SupabaseClient client;

  MedicationRepository({required this.client});

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  // ─────────────────────────────────────────────
  // Fetch all medications for the current user
  // (RLS filters by user automatically)
  // ─────────────────────────────────────────────
  Future<List<MedicationModel>> fetchMedications() async {
    try {
      final response = await client
          .from('medications')
          .select()
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => MedicationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      debugPrint('[MedicationRepository] fetchMedications PostgrestException:');
      debugPrint('  message : ${e.message}');
      debugPrint('  code    : ${e.code}');
      debugPrint('  details : ${e.details}');
      debugPrint('  hint    : ${e.hint}');
      rethrow;
    } catch (e, st) {
      debugPrint('[MedicationRepository] fetchMedications unexpected error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // Add a new medication and return the saved row
  // ─────────────────────────────────────────────
  Future<MedicationModel> addMedication(MedicationModel med) async {
    final uid = client.auth.currentUser!.id;
    try {
      final response = await client.from('medications').insert({
        'user_id': uid,
        'name': med.name,
        'dosage': med.dosage,
        'scheduled_time': med.scheduledTime,
        'icon_name': med.iconName,
      }).select().single();

      return MedicationModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('[MedicationRepository] addMedication PostgrestException:');
      debugPrint('  message : ${e.message}');
      debugPrint('  code    : ${e.code}');
      debugPrint('  details : ${e.details}');
      debugPrint('  hint    : ${e.hint}');
      rethrow;
    } catch (e, st) {
      debugPrint('[MedicationRepository] addMedication unexpected error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // Delete a medication by ID
  // ─────────────────────────────────────────────
  Future<void> deleteMedication(String id) async {
    try {
      await client.from('medications').delete().eq('id', id);
    } on PostgrestException catch (e) {
      debugPrint('[MedicationRepository] deleteMedication PostgrestException:');
      debugPrint('  message : ${e.message}');
      debugPrint('  code    : ${e.code}');
      debugPrint('  details : ${e.details}');
      debugPrint('  hint    : ${e.hint}');
      rethrow;
    } catch (e, st) {
      debugPrint('[MedicationRepository] deleteMedication unexpected error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // Upsert an intake log for today
  // ─────────────────────────────────────────────
  Future<IntakeLogModel> logIntake({
    required String medicationId,
    required String status,
  }) async {
    final uid = client.auth.currentUser!.id;
    try {
      final payload = <String, dynamic>{
        'user_id': uid,
        'medication_id': medicationId,
        'scheduled_date': _today,
        'status': status,
        'taken_at': status == 'taken' ? DateTime.now().toIso8601String() : null,
      };

      final response = await client
          .from('intake_logs')
          .upsert(
            payload,
            onConflict: 'medication_id,scheduled_date',
          )
          .select()
          .single();

      return IntakeLogModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('[MedicationRepository] logIntake PostgrestException:');
      debugPrint('  message : ${e.message}');
      debugPrint('  code    : ${e.code}');
      debugPrint('  details : ${e.details}');
      debugPrint('  hint    : ${e.hint}');
      rethrow;
    } catch (e, st) {
      debugPrint('[MedicationRepository] logIntake unexpected error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // Fetch today's intake logs for the current user
  // ─────────────────────────────────────────────
  Future<List<IntakeLogModel>> fetchTodayIntakeLogs() async {
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
    } on PostgrestException catch (e) {
      debugPrint(
          '[MedicationRepository] fetchTodayIntakeLogs PostgrestException:');
      debugPrint('  message : ${e.message}');
      debugPrint('  code    : ${e.code}');
      debugPrint('  details : ${e.details}');
      debugPrint('  hint    : ${e.hint}');
      rethrow;
    } catch (e, st) {
      debugPrint(
          '[MedicationRepository] fetchTodayIntakeLogs unexpected error: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
