import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/shared_preferences/shared_pref_enum.dart';
import '../services/shared_preferences/shared_pref_helper.dart';

part 'theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    return ref.watch(initialThemeModeProvider);
  }

  Future<void> toggleThemeMode() async {
    final isDarkMode = state == ThemeMode.dark;
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    state = newMode;

    await SharedPrefHelper.set(
      SharedPrefKey.isDarkMode,
      newMode == ThemeMode.dark,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await SharedPrefHelper.set(
        SharedPrefKey.isDarkMode, mode == ThemeMode.dark);
  }
}

// FOR INITIAL STATE
final initialThemeModeProvider = Provider<ThemeMode>((ref) {
  throw UnimplementedError();
});
