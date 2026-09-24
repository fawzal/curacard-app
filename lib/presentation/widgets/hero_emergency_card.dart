import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/profile_model.dart';

class HeroEmergencyCard extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback? onEditPressed;

  const HeroEmergencyCard({
    super.key,
    required this.profile,
    this.onEditPressed,
  });

  Future<void> _makeEmergencyCall(BuildContext context) async {
    final phoneUri = Uri.parse('tel:${profile.emergencyContactPhone}');
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Memanggil ${profile.emergencyContactPhone}...'),
              backgroundColor: AppTheme.textMain,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memanggil: ${profile.emergencyContactPhone}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Theme.of(context).colorScheme.primary,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Card Header: Modern Clean Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'ID MEDIS DARURAT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Blood Type Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.water_drop,
                      size: 13,
                      color: AppTheme.primaryCoral,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.bloodType,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryCoral,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Patient Name
          Text(
            profile.fullName.isEmpty ? 'Atur Profil Darurat' : profile.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Allergies & Conditions Row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (profile.allergies.isNotEmpty)
                _buildInfoBadge(
                  icon: Icons.warning_amber_rounded,
                  label: 'Alergi: ${profile.allergies.join(", ")}',
                ),
              if (profile.chronicConditions.isNotEmpty)
                _buildInfoBadge(
                  icon: Icons.favorite_border_rounded,
                  label: 'Kondisi: ${profile.chronicConditions.join(", ")}',
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              // Emergency Call Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _makeEmergencyCall(context),
                    icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                    label: Text(
                      'Hubungi',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Edit Button
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: onEditPressed,
                  icon: Icon(Icons.edit_rounded, color: Theme.of(context).colorScheme.primary, size: 18),
                  label: Text(
                    'Edit ID',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
