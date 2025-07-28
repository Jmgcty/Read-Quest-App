import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/shared_pref_value_converter.dart';
import 'shared_pref_enum.dart';

class SharedPrefHelper {
  static String _key(SharedPrefKey key) => key.name;

  static Future<void> set(SharedPrefKey key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final k = _key(key);

    if (value == null) return;

    final v =
        jsonEncode({'type': value.runtimeType.toString(), 'value': value});
    await prefs.setString(k, v);
  }

  static Future<dynamic> get(SharedPrefKey key) async {
    final prefs = await SharedPreferences.getInstance();
    final k = _key(key);
    final raw = prefs.getString(k);
    if (raw == null) return null;
    return sharedPrefValueConverter(raw);
  }

  static Future<void> remove(SharedPrefKey key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key.name);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
