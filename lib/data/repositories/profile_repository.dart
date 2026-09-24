import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final SupabaseClient client;

  ProfileRepository({required this.client});

  // ─────────────────────────────────────────────
  // Fetch profile + emergency contacts from Supabase
  // ─────────────────────────────────────────────
  Future<ProfileModel> fetchProfile() async {
    final uid = client.auth.currentUser!.id;
    try {
      final response = await client
          .from('profiles')
          .select('*, contacts:emergency_contacts(*)')
          .eq('id', uid)
          .single();

      return ProfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('[ProfileRepository] fetchProfile PostgrestException:');
      debugPrint('  message : ${e.message}');
      debugPrint('  code    : ${e.code}');
      debugPrint('  details : ${e.details}');
      debugPrint('  hint    : ${e.hint}');
      rethrow;
    } catch (e, st) {
      debugPrint('[ProfileRepository] fetchProfile unexpected error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // Upsert profile then upsert emergency contacts
  // ─────────────────────────────────────────────
  Future<ProfileModel> upsertProfile(ProfileModel profile) async {
    final uid = client.auth.currentUser!.id;

    try {
      // 1. Upsert the profile row (id always comes from auth, not model)
      await client.from('profiles').upsert({
        'id': uid,
        'full_name': profile.fullName,
        'blood_type': profile.bloodType,
        'allergies': profile.allergies,
        'chronic_conditions': profile.chronicConditions,
        'updated_at': DateTime.now().toIso8601String(),
      }).select();

      // 2. Replace emergency contacts:
      //    Delete existing ones, then insert fresh list.
      await client
          .from('emergency_contacts')
          .delete()
          .eq('user_id', uid);

      if (profile.emergencyContacts.isNotEmpty) {
        final contactsPayload = profile.emergencyContacts.map((c) => {
              'user_id': uid,
              'name': c.name,
              'relation': c.relation,
              'phone': c.phone,
              'is_primary': c.isPrimary,
            }).toList();

        await client
            .from('emergency_contacts')
            .insert(contactsPayload)
            .select();
      }

      // 3. Return fresh data from Supabase
      return await fetchProfile();
    } on PostgrestException catch (e) {
      debugPrint('[ProfileRepository] upsertProfile PostgrestException:');
      debugPrint('  message : ${e.message}');
      debugPrint('  code    : ${e.code}');
      debugPrint('  details : ${e.details}');
      debugPrint('  hint    : ${e.hint}');
      rethrow;
    } catch (e, st) {
      debugPrint('[ProfileRepository] upsertProfile unexpected error: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
