import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/services/shared_preferences/shared_pref_helper.dart';
import 'package:read_quest/core/themes/app_theme.dart';

import 'core/services/shared_preferences/shared_pref_enum.dart';
import 'core/themes/theme_mode_provider.dart';
import 'features/start/provider/start_provider.dart';

import 'routing/router_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // await SharedPrefHelper.clear();
  await dotenv.load(fileName: ".env");
  //1
  final isDarkMode =
      await SharedPrefHelper.get(SharedPrefKey.isDarkMode) ?? false;
  final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

  final isStarted =
      await SharedPrefHelper.get(SharedPrefKey.isGetStarted) ?? false;

  runApp(
    ProviderScope(
      overrides: [
        initialThemeModeProvider.overrideWith((ref) => themeMode),
        initialStartProvider.overrideWith((ref) => isStarted),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    //
    return MaterialApp.router(
      title: 'Read Quest',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
