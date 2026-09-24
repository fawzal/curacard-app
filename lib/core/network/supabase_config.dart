import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://lepkgmfsqhguujoieapj.supabase.co';
  static const String publishableKey =
      'sb_publishable_Sc81-2j2MOWJmF7BugSkWg_AjKKdj56';

  static String? lastErrorMessage;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: publishableKey, // 'anonKey' is the current valid param name in supabase_flutter
    );
    debugPrint('[SupabaseConfig] Initialized successfully.');
  }

  static SupabaseClient get client => Supabase.instance.client;

  /// Connectivity check — pings profiles table. Used by AmbientHeader diagnostic.
  static Future<bool> verifyConnectivity() async {
    try {
      await client
          .from('profiles')
          .select('id')
          .limit(1)
          .timeout(const Duration(seconds: 5));
      lastErrorMessage = null;
      return true;
    } on PostgrestException catch (e) {
      lastErrorMessage = 'DB Error [${e.code}]: ${e.message}';
      return false;
    } catch (e) {
      lastErrorMessage = e.toString();
      return false;
    }
  }
}
