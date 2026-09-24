class EmergencyContactModel {
  final String id;
  final String name;
  final String relation; // e.g. 'Primary Physician', 'Spouse', 'Parent', 'Hospital'
  final String phone;
  final bool isPrimary;

  const EmergencyContactModel({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
    this.isPrimary = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'phone': phone,
      'is_primary': isPrimary,
    };
  }

  factory EmergencyContactModel.fromMap(Map<String, dynamic> map) {
    return EmergencyContactModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Emergency Contact',
      relation: map['relation']?.toString() ?? 'Family / Doctor',
      phone: map['phone']?.toString() ?? '911',
      isPrimary: map['is_primary'] == true,
    );
  }
}
