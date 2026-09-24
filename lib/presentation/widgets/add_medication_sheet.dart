import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/network/supabase_config.dart';
import '../../core/theme/app_theme.dart';
import '../providers/medication_provider.dart';

class AddMedicationSheet extends ConsumerStatefulWidget {
  const AddMedicationSheet({super.key});

  @override
  ConsumerState<AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends ConsumerState<AddMedicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  String _selectedTime = '08:00 AM';
  String _selectedIcon = 'pill';
  bool _isLoading = false;

  final List<String> _times = [
    '07:00 AM',
    '08:00 AM',
    '12:00 PM',
    '06:00 PM',
    '08:00 PM',
    '10:00 PM',
  ];

  final List<Map<String, String>> _icons = [
    {'name': 'pill', 'label': 'Pil'},
    {'name': 'inhaler', 'label': 'Inhaler'},
    {'name': 'tablet', 'label': 'Tablet'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final userId = SupabaseConfig.client.auth.currentUser!.id;

      await SupabaseConfig.client.from('medications').insert({
        'user_id': userId,
        'name': _nameController.text.trim(),
        'dosage': _dosageController.text.trim(),
        'scheduled_time': _selectedTime,
        'icon_name': _selectedIcon,
      });

      // Refresh medication list from Supabase
      ref.invalidate(medicationNotifierProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil disimpan')),
        );
      }
    } on PostgrestException catch (e) {
      debugPrint(
        'PostgrestException: ${e.message} | code: ${e.code} | details: ${e.details} | hint: ${e.hint}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan resep: ${e.message}'),
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tambah Resep Baru',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration(
                  'Nama Obat (mis. Parasetamol)',
                  Icons.medication_rounded,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nama obat wajib diisi' : null,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _dosageController,
                decoration: _inputDecoration(
                  'Dosis (mis. 500 mg - 1 Tablet)',
                  Icons.scale_rounded,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Dosis wajib diisi' : null,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 14),

              LayoutBuilder(
                builder: (context, constraints) => DropdownMenu<String>(
                  width: constraints.maxWidth,
                  initialSelection: _selectedTime,
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  leadingIcon: const Icon(Icons.access_time_rounded, color: AppTheme.textSecondary, size: 20),
                  hintText: 'Waktu Minum',
                  enabled: !_isLoading,
                  dropdownMenuEntries: _times.map((time) {
                    return DropdownMenuEntry<String>(value: time, label: time);
                  }).toList(),
                  onSelected: (val) {
                    if (val != null) setState(() => _selectedTime = val);
                  },
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Ikon Obat',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: _icons.map((item) {
                  final isSelected = _selectedIcon == item['name'];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: _isLoading
                            ? null
                            : () => setState(() => _selectedIcon = item['name']!),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryCoral.withOpacity(0.12)
                                : AppTheme.canvasBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryCoral
                                  : Colors.black12,
                            ),
                          ),
                          child: Text(
                            item['label']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppTheme.primaryCoral
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
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
                      : const Text(
                          'Simpan Resep',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
    );
  }
}
