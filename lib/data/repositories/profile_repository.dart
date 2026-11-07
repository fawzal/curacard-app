import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../models/emergency_contact_model.dart';

class ProfileRepository {
  final SupabaseClient client;

  ProfileRepository({required this.client});

  static ProfileModel _mockProfile = ProfileModel(
    id: 'tester-id',
    fullName: 'Tester CuraCard',
    bloodType: 'O+',
    allergies: const ['Penicillin', 'Sulfa'],
    chronicConditions: const ['Hipertensi'],
    contacts: const [
      EmergencyContactModel(
        id: 'c1',
        name: 'Dr. Sarah Jenkins',
        relation: 'Dokter Pribadi',
        phone: '081234567890',
        isPrimary: true,
      ),
    ],
    isCompleted: true,
    updatedAt: DateTime.now(),
  );

  // ─────────────────────────────────────────────
  // Fetch profile + emergency contacts from Supabase
  // ─────────────────────────────────────────────
  Future<ProfileModel> fetchProfile() async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) {
      return _mockProfile;
    }
    try {
      final response = await client
          .from('profiles')
          .select('*, contacts:emergency_contacts(*)')
          .eq('id', uid)
          .single();

      return ProfileModel.fromJson(response);
    } catch (e) {
      debugPrint('[ProfileRepository] Offline fallback to mock profile: $e');
      return _mockProfile;
    }
  }

  // ─────────────────────────────────────────────
  // Upsert profile then upsert emergency contacts
  // ─────────────────────────────────────────────
  Future<ProfileModel> upsertProfile(ProfileModel profile) async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) {
      _mockProfile = profile;
      return _mockProfile;
    }

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
    } catch (e) {
      debugPrint('[ProfileRepository] Offline fallback on upsertProfile: $e');
      _mockProfile = profile;
      return _mockProfile;
    }
  }
}
