import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/supabase_config.dart';
import '../../core/theme/app_theme.dart';
import '../providers/profile_provider.dart';

class AmbientHeader extends ConsumerStatefulWidget {
  final String userInitials;

  const AmbientHeader({
    super.key,
    this.userInitials = 'AR',
  });

  @override
  ConsumerState<AmbientHeader> createState() => _AmbientHeaderState();
}

class _AmbientHeaderState extends ConsumerState<AmbientHeader> {
  bool _isSupabaseConnected = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connected = await SupabaseConfig.verifyConnectivity();
    if (mounted) {
      setState(() {
        _isSupabaseConnected = connected;
        _isChecking = false;
      });
    }
  }

  void _showDiagnosticDialog() {
    final error = SupabaseConfig.lastErrorMessage;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _isSupabaseConnected ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              color: _isSupabaseConnected ? AppTheme.successMint : Colors.orange.shade800,
            ),
            const SizedBox(width: 8),
            Text(
              _isSupabaseConnected ? 'Terhubung' : 'Pemberitahuan Status',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'URL Supabase:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 2),
            SelectableText(
              SupabaseConfig.supabaseUrl,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMain),
            ),
            const SizedBox(height: 14),

            const Text(
              'Status:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              _isSupabaseConnected
                  ? '🟢 Online & Terhubung ke Database'
                  : '🟡 Offline (Menggunakan Penyimpanan Lokal)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _isSupabaseConnected ? AppTheme.successMint : Colors.orange.shade800,
              ),
            ),

            if (!_isSupabaseConnected && error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pesan Diagnostik:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isChecking = true);
              _checkConnectivity();
            },
            child: const Text('Cek Ulang Koneksi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch profile state to get real name
    final profileState = ref.watch(profileNotifierProvider);
    final String fullName = profileState.maybeWhen(
      data: (profile) => profile.fullName.isNotEmpty ? profile.fullName : 'User',
      orElse: () => 'User',
    );

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User Welcome Info (Logo removed)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Halo,',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                fullName,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          // Live Supabase Status Indicator Badge
          InkWell(
            onTap: _showDiagnosticDialog,
            borderRadius: BorderRadius.circular(16.0),
            child: Card.outlined(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      _isSupabaseConnected ? Icons.cloud_done_rounded : Icons.wifi_off_rounded,
                      size: 16,
                      color: _isSupabaseConnected ? Theme.of(context).colorScheme.secondary : Colors.orange.shade800,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isChecking
                          ? 'Mengecek...'
                          : (_isSupabaseConnected ? 'Online' : 'Mode Offline'),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _isSupabaseConnected ? Theme.of(context).colorScheme.secondary : Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
