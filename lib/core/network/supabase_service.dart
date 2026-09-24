import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/emergency_contact_model.dart';

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  void _validateSession() {
    if (_client.auth.currentUser == null) {
      throw Exception('Sesi tidak valid: User belum login atau sesi telah kedaluwarsa.');
    }
  }

  void _handleException(dynamic e, StackTrace st) {
    if (e is PostgrestException) {
      debugPrint('--- PostgrestException ---');
      debugPrint('Message: ${e.message}');
      debugPrint('Code: ${e.code}');
      debugPrint('Details: ${e.details}');
      debugPrint('Hint: ${e.hint}');
      debugPrint('--------------------------');
      throw Exception('Database Error: ${e.message}');
    }
    debugPrint('Unknown Error: $e\n$st');
    throw Exception('Terjadi kesalahan yang tidak terduga: $e');
  }

  /// Profile Operations
  Future<void> upsertProfile(ProfileModel profile) async {
    _validateSession();
    try {
      final userId = _client.auth.currentUser!.id;
      final supabasePayload = {
        'id': userId,
        'full_name': profile.fullName,
        'blood_type': profile.bloodType,
        'allergies': profile.allergies,
        'chronic_conditions': profile.chronicConditions,
        'updated_at': profile.updatedAt.toIso8601String(),
      };
      
      await _client
          .from('profiles')
          .upsert(supabasePayload)
          .select(); // Ensure operation succeeds
          
    } catch (e, st) {
      _handleException(e, st);
    }
  }

  /// Emergency Contacts Operations
  Future<void> insertContact(EmergencyContactModel contact) async {
    _validateSession();
    try {
      final userId = _client.auth.currentUser!.id;
      final payload = {
        'id': contact.id, // Ensure UUID is generated at UI layer
        'user_id': userId,
        'name': contact.name,
        'relation': contact.relation,
        'phone': contact.phone,
        'is_primary': contact.isPrimary,
      };

      await _client
          .from('emergency_contacts')
          .insert(payload)
          .select();
    } catch (e, st) {
      _handleException(e, st);
    }
  }
  
  Future<void> upsertContacts(List<EmergencyContactModel> contacts) async {
    _validateSession();
    if (contacts.isEmpty) return;
    try {
      final userId = _client.auth.currentUser!.id;
      final payload = contacts.map((c) => {
        'id': c.id,
        'user_id': userId,
        'name': c.name,
        'relation': c.relation,
        'phone': c.phone,
        'is_primary': c.isPrimary,
      }).toList();

      await _client
          .from('emergency_contacts')
          .upsert(payload)
          .select();
    } catch (e, st) {
      _handleException(e, st);
    }
  }

  /// Medication Operations
  Future<void> insertMedication({
    required String id,
    required String name,
    required String dosage,
    required String scheduledTime,
    String iconName = 'pill',
  }) async {
    _validateSession();
    try {
      final userId = _client.auth.currentUser!.id;
      final payload = {
        'id': id,
        'user_id': userId,
        'name': name,
        'dosage': dosage,
        'scheduled_time': scheduledTime,
        'icon_name': iconName,
      };

      await _client
          .from('medications')
          .insert(payload)
          .select();
    } catch (e, st) {
      _handleException(e, st);
    }
  }
}
