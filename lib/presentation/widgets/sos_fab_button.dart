import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../providers/profile_provider.dart';

class SosFabButton extends ConsumerWidget {
  const SosFabButton({super.key});

  Future<void> _makeCall(BuildContext context, String phone) async {
    final uri = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dialing $phone...')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trigger dial: $phone')),
        );
      }
    }
  }

  void _showEmergencySheet(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.read(profileNotifierProvider);
    final profile = asyncProfile.value;
    final primaryPhone = profile?.emergencyContactPhone ?? '112';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.textMain,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF991B1B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sos_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            const Text(
              'EMERGENCY CALL HOTLINE',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Select one-tap emergency call option below:',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 16),

            // Button 1: Call 112 Emergency
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _makeCall(context, '112');
                },
                icon: const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 18),
                label: const Text(
                  'Call 112 National Emergency',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryCoral,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Button 2: Call Primary Contact
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _makeCall(context, primaryPhone);
                },
                icon: const Icon(Icons.phone_in_talk_rounded, color: AppTheme.textMain, size: 18),
                label: Text(
                  'Call ${profile?.emergencyContactName ?? "Doctor"} ($primaryPhone)',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      heroTag: 'sos_btn',
      onPressed: () => _showEmergencySheet(context, ref),
      backgroundColor: const Color(0xFF991B1B), // Dark Maroon for SOS
      elevation: 4,
      shape: const CircleBorder(),
      child: const Text(
        'SOS',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
