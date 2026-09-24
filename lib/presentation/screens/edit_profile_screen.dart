import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/emergency_contact_model.dart';
import '../../data/models/profile_model.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final ProfileModel initialProfile;

  const EditProfileScreen({
    super.key,
    required this.initialProfile,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _allergiesController;
  late TextEditingController _conditionsController;
  late TextEditingController _contactNameController;
  late TextEditingController _contactPhoneController;
  late String _selectedBloodType;

  final List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Unknown',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialProfile.fullName,
    );
    _allergiesController = TextEditingController(
      text: widget.initialProfile.allergies.join(', '),
    );
    _conditionsController = TextEditingController(
      text: widget.initialProfile.chronicConditions.join(', '),
    );

    final existingPrimary = widget.initialProfile.contacts
        .where((c) => c.isPrimary)
        .firstOrNull;

    _contactNameController = TextEditingController(
      text: existingPrimary?.name ?? widget.initialProfile.emergencyContactName,
    );
    _contactPhoneController = TextEditingController(
      text: existingPrimary?.phone ?? widget.initialProfile.emergencyContactPhone,
    );

    _selectedBloodType =
        widget.initialProfile.bloodType.isEmpty ||
                widget.initialProfile.bloodType == 'Unknown'
            ? 'O+'
            : widget.initialProfile.bloodType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _allergiesController.dispose();
    _conditionsController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final allergiesList = _allergiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final conditionsList = _conditionsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final existingPrimary = widget.initialProfile.contacts
        .where((c) => c.isPrimary)
        .firstOrNull;

    final primaryContact = EmergencyContactModel(
      id: existingPrimary?.id ?? 'pc-${DateTime.now().millisecondsSinceEpoch}',
      name: _contactNameController.text.trim(),
      relation: 'Dokter / Keluarga',
      phone: _contactPhoneController.text.trim(),
      isPrimary: true,
    );

    final updated = widget.initialProfile.copyWith(
      fullName: _nameController.text.trim(),
      bloodType: _selectedBloodType,
      allergies: allergiesList,
      chronicConditions: conditionsList,
      contacts: [
        primaryContact,
        ...widget.initialProfile.contacts.where((c) => !c.isPrimary),
      ],
      isCompleted: true,
    );

    ref.read(profileNotifierProvider.notifier).updateProfile(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atur ID Medis Darurat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppTheme.canvasBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Identitas Pribadi ──────────────────────────
                _buildSectionHeader('Identitas Pribadi'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration(
                    'Nama Lengkap',
                    Icons.person_outline,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) => DropdownMenu<String>(
                    width: constraints.maxWidth,
                    initialSelection: _selectedBloodType,
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    leadingIcon: const Icon(Icons.water_drop_outlined, color: AppTheme.textSecondary, size: 20),
                    hintText: 'Golongan Darah',
                    dropdownMenuEntries: _bloodTypes.map((type) {
                      return DropdownMenuEntry<String>(value: type, label: type);
                    }).toList(),
                    onSelected: (val) {
                      if (val != null) setState(() => _selectedBloodType = val);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ── Peringatan Medis Kritis ────────────────────
                _buildSectionHeader('Peringatan Medis Kritis'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _allergiesController,
                  decoration: _buildInputDecoration(
                    'Alergi (pisahkan dengan koma)',
                    Icons.warning_amber_rounded,
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _conditionsController,
                  decoration: _buildInputDecoration(
                    'Kondisi Kronis (pisahkan dengan koma)',
                    Icons.favorite_border_rounded,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Kontak Darurat Utama ───────────────────────
                _buildSectionHeader('Kontak Darurat Utama'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactNameController,
                  decoration: _buildInputDecoration(
                    'Nama Kontak / Dokter',
                    Icons.contact_phone_outlined,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Nama kontak wajib diisi' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _contactPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(
                    'Nomor Telepon',
                    Icons.phone_outlined,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Nomor telepon wajib diisi' : null,
                ),
                const SizedBox(height: 28),

                // ── Simpan ────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _saveProfile,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryCoral,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                    child: const Text(
                      'Simpan ID Medis',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppTheme.textMain,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
      // borders and fill color are now inherited globally from AppTheme
    );
  }
}
