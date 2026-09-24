import 'convert_helpers.dart';
import 'emergency_contact_model.dart';

class ProfileModel {
  final String id;
  final String fullName;
  final String bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;

  /// `contacts` diambil dari join `emergency_contacts` di Supabase
  final List<EmergencyContactModel> contacts;
  final bool isCompleted;
  final DateTime updatedAt;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.bloodType,
    required this.allergies,
    required this.chronicConditions,
    required this.contacts,
    this.isCompleted = false,
    required this.updatedAt,
  });

  // Alias untuk akses kontak darurat dari repository baru
  List<EmergencyContactModel> get emergencyContacts => contacts;

  // ─── Computed getters ───────────────────────────────────────────────────────

  String get emergencyContactName => contacts.isNotEmpty
      ? contacts.firstWhere((c) => c.isPrimary, orElse: () => contacts.first).name
      : 'Belum ada kontak';

  String get emergencyContactPhone => contacts.isNotEmpty
      ? contacts.firstWhere((c) => c.isPrimary, orElse: () => contacts.first).phone
      : '112';

  // ─── Factory: empty profile for new users ───────────────────────────────────

  factory ProfileModel.initialNewUser({String userId = ''}) {
    return ProfileModel(
      id: userId,
      fullName: '',
      bloodType: 'Unknown',
      allergies: const [],
      chronicConditions: const [],
      contacts: const [],
      isCompleted: false,
      updatedAt: DateTime.now(),
    );
  }

  // ─── Serialization ──────────────────────────────────────────────────────────

  /// Digunakan untuk Supabase upsert (hanya kolom profile, bukan contacts)
  Map<String, dynamic> toSupabasePayload(String uid) {
    return {
      'id': uid,
      'full_name': fullName,
      'blood_type': bloodType,
      'allergies': allergies,
      'chronic_conditions': chronicConditions,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Supabase returns contacts as a joined list under 'contacts' key
    List<EmergencyContactModel> parsedContacts = [];
    if (json['contacts'] != null && json['contacts'] is List) {
      parsedContacts = (json['contacts'] as List)
          .map((c) => EmergencyContactModel.fromMap(c as Map<String, dynamic>))
          .toList();
    }

    final name = json['full_name']?.toString() ?? '';
    final completed = name.isNotEmpty && name != 'Unknown';

    return ProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: name,
      bloodType: json['blood_type']?.toString() ?? 'Unknown',
      allergies: parseStringList(json['allergies']),
      chronicConditions: parseStringList(json['chronic_conditions']),
      contacts: parsedContacts,
      isCompleted: completed,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // Alias untuk backward compatibility
  factory ProfileModel.fromMap(Map<String, dynamic> map) =>
      ProfileModel.fromJson(map);

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? bloodType,
    List<String>? allergies,
    List<String>? chronicConditions,
    List<EmergencyContactModel>? contacts,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      contacts: contacts ?? this.contacts,
      isCompleted: isCompleted ?? this.isCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
