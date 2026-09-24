import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/supabase_config.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

// ─────────────────────────────────────────────
// Repository provider
// ─────────────────────────────────────────────
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(client: SupabaseConfig.client);
});

// ─────────────────────────────────────────────
// StateNotifier
// ─────────────────────────────────────────────
class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.fetchProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(ProfileModel updated) async {
    try {
      final saved = await _repository.upsertProfile(updated);
      state = AsyncValue.data(saved);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ─────────────────────────────────────────────
// Notifier provider
// ─────────────────────────────────────────────
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel>>((ref) {
  return ProfileNotifier(ref.watch(profileRepositoryProvider));
});
