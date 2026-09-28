import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  
  // Initialize Notification Service
  await NotificationService().init();
  await NotificationService().requestPermissions();
  
  runApp(const ProviderScope(child: CuraCardApp()));
}

class CuraCardApp extends StatelessWidget {
  const CuraCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuraCard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
