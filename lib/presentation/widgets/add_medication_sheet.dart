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
  
  int _frequency = 1;
  final List<String> _selectedTimes = ['08:00 AM', '01:00 PM', '07:00 PM'];
  String _selectedIcon = 'pill';
  bool _useAlarm = false;
  bool _isLoading = false;



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
      final timesToSave = _selectedTimes.sublist(0, _frequency);

      await SupabaseConfig.client.from('medications').insert({
        'user_id': userId,
        'name': _nameController.text.trim(),
        'dosage': _dosageController.text.trim(),
        'scheduled_times': timesToSave,
        'icon_name': _selectedIcon,
        'use_alarm': _useAlarm,
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

  Future<void> _pickTime(BuildContext context, int index) async {
    final currentParts = _selectedTimes[index].split(' ');
    final timeParts = currentParts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    if (currentParts.length > 1) {
      if (currentParts[1] == 'PM' && hour != 12) hour += 12;
      if (currentParts[1] == 'AM' && hour == 12) hour = 0;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );

    if (picked != null) {
      // Format to "hh:mm AM/PM"
      int h = picked.hour;
      String period = 'AM';
      if (h >= 12) {
        period = 'PM';
        if (h > 12) h -= 12;
      }
      if (h == 0) h = 12;
      
      final String formattedTime = '${h.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} $period';
      
      setState(() {
        _selectedTimes[index] = formattedTime;
      });
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
              const SizedBox(height: 16),

              const Text(
                'Frekuensi Minum Obat',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 1, label: Text('1x Sehari')),
                    ButtonSegment(value: 2, label: Text('2x Sehari')),
                    ButtonSegment(value: 3, label: Text('3x Sehari')),
                  ],
                  selected: {_frequency},
                  onSelectionChanged: (newSelection) {
                    if (!_isLoading) {
                      setState(() => _frequency = newSelection.first);
                    }
                  },
                  showSelectedIcon: false,
                ),
              ),
              const SizedBox(height: 16),

              // Time Pickers based on frequency
              ...List.generate(_frequency, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: _isLoading ? null : () => _pickTime(context, index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, color: AppTheme.textSecondary, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _selectedTimes[index],
                            style: const TextStyle(fontSize: 16, color: AppTheme.textMain),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textSecondary),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 4),

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
                                ? AppTheme.primaryCoral.withAlpha(30)
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
              const SizedBox(height: 16),

              // Switch for Alarm
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.canvasBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gunakan Alarm Berdering',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Jika dinonaktifkan, Anda hanya akan menerima notifikasi pesan standar tanpa nada dering panjang.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: _useAlarm,
                      activeTrackColor: AppTheme.primaryCoral.withAlpha(100),
                      activeThumbColor: AppTheme.primaryCoral,
                      onChanged: _isLoading
                          ? null
                          : (val) {
                              setState(() {
                                _useAlarm = val;
                              });
                            },
                    ),
                  ],
                ),
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
