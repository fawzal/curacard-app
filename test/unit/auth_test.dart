import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Auth & Onboarding Persistence Tests', () {
    test('onboarding state defaults to false and persists when completed', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      expect(prefs.getBool('curacard_onboarding_done'), isNull);

      await prefs.setBool('curacard_onboarding_done', true);
      expect(prefs.getBool('curacard_onboarding_done'), isTrue);
    });

    test('authentication state defaults to false and persists when authenticated', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      expect(prefs.getBool('curacard_authenticated'), isNull);

      await prefs.setBool('curacard_authenticated', true);
      expect(prefs.getBool('curacard_authenticated'), isTrue);
    });
  });
}
