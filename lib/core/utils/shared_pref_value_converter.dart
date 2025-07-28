import 'dart:convert';

dynamic sharedPrefValueConverter(dynamic rawValue) {
  try {
    final decoded = jsonDecode(rawValue);
    final type = decoded['type'];
    final value = decoded['value'];

    switch (type) {
      case 'int':
        return value as int;
      case 'double':
        return value as double;
      case 'bool':
        return value as bool;
      case 'String':
        return value as String;
      case 'List':
        return List<dynamic>.from(value);
      case 'Map':
        return Map<String, dynamic>.from(value);
      default:
        return value; // if unknown, return raw
    }
  } catch (_) {
    return null;
  }
}
