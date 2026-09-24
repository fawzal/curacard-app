List<String> parseStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  if (value is String) {
    // Handle string representations like "{Penicillin,Sulfa}"
    final cleaned = value.replaceAll('{', '').replaceAll('}', '').trim();
    if (cleaned.isEmpty) return [];
    return cleaned.split(',').map((e) => e.trim()).toList();
  }
  return [];
}
