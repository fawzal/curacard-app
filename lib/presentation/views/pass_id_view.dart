import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/profile_provider.dart';
import '../screens/edit_profile_screen.dart';
import '../widgets/hero_emergency_card.dart';

class PassIdView extends ConsumerWidget {
  const PassIdView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(profileNotifierProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Emergency Health Pass',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textMain,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'First responders can access vital medical info in <3 seconds',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 16),

            // High-Priority Incomplete Profile Setup Banner (For New Users)
            asyncProfile.maybeWhen(
              data: (profile) {
                if (!profile.isCompleted) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(initialProfile: profile),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB), // Clean Warm Amber
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(color: const Color(0xFFFCD34D), width: 1.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PASS ID INCOMPLETE',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF92400E),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Tap to fill blood type, allergies & emergency contact now.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF92400E), size: 14),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              orElse: () => const SizedBox.shrink(),
            ),

            // Monzo Hero Emergency Card
            asyncProfile.when(
              data: (profile) => HeroEmergencyCard(
                profile: profile,
                onEditPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(initialProfile: profile),
                    ),
                  );
                },
              ),
              loading: () => Container(
                height: 180,
                decoration: BoxDecoration(
                  color: AppTheme.primaryCoral.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              error: (err, _) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCoral,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                child: Text(
                  'Error loading profile: $err',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Health Highlights Box
            asyncProfile.maybeWhen(
              data: (profile) => Card.outlined(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: const Color(0xFF991B1B), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Panduan Medis',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildHighlightRow(
                        context,
                        'Gol. Darah:',
                        profile.bloodType,
                        Icons.water_drop_outlined,
                      ),
                      Divider(height: 16, color: Theme.of(context).colorScheme.outlineVariant),
                      _buildHighlightRow(
                        context,
                        'Alergi Diketahui:',
                        profile.allergies.isEmpty ? 'Tidak Ada' : profile.allergies.join(', '),
                        Icons.warning_amber_rounded,
                      ),
                      Divider(height: 16, color: Theme.of(context).colorScheme.outlineVariant),
                      _buildHighlightRow(
                        context,
                        'Kondisi Kronis:',
                        profile.chronicConditions.isEmpty ? 'Tidak Ada' : profile.chronicConditions.join(', '),
                        Icons.favorite_border_rounded,
                      ),
                    ],
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightRow(BuildContext context, String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
