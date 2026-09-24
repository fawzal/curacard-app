import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/network/supabase_config.dart';
import '../../core/theme/app_theme.dart';
import '../providers/profile_provider.dart';

class AddContactDialog extends ConsumerStatefulWidget {
  const AddContactDialog({super.key});

  @override
  ConsumerState<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends ConsumerState<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedRelation = 'Orang Tua';
  bool _isPrimary = false;
  bool _isLoading = false;

  final List<String> _relations = [
    'Orang Tua',
    'Pasangan',
    'Anak',
    'Kakak/Adik',
    'Dokter Pribadi',
    'Perawat',
    'Teman Dekat',
    'Lainnya',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final userId = SupabaseConfig.client.auth.currentUser!.id;

      await SupabaseConfig.client.from('emergency_contacts').insert({
        'user_id': userId,
        'name': _nameController.text.trim(),
        'relation': _selectedRelation,
        'phone': _phoneController.text.trim(),
        'is_primary': _isPrimary,
      });

      // Refresh profile so the new contact appears immediately
      ref.invalidate(profileNotifierProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kontak darurat berhasil ditambahkan')),
        );
      }
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException: ${e.message} | code: ${e.code} | details: ${e.details} | hint: ${e.hint}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan kontak: ${e.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Tambah Kontak Darurat',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Nama Kontak',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) => DropdownMenu<String>(
                  width: constraints.maxWidth,
                  initialSelection: _selectedRelation,
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  leadingIcon: const Icon(Icons.badge_outlined, color: AppTheme.textSecondary, size: 20),
                  hintText: 'Hubungan / Peran',
                  enabled: !_isLoading,
                  dropdownMenuEntries: _relations.map((r) {
                    return DropdownMenuEntry<String>(value: r, label: r);
                  }).toList(),
                  onSelected: (val) {
                    if (val != null) setState(() => _selectedRelation = val);
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Nomor Telepon',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nomor telepon wajib diisi' : null,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 4),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Jadikan kontak utama'),
                value: _isPrimary,
                onChanged: _isLoading
                    ? null
                    : (val) => setState(() => _isPrimary = val ?? false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
