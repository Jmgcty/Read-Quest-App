import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  //
  static ThemeData light = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundWhite,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.backgroundWhite,
    ),
    elevatedButtonTheme: AppButtonThemeData.buttonThemeData,
    inputDecorationTheme: AppInputDecorationTheme.inputDecorationTheme,
    textTheme: AppTextTheme.appTextTheme,
  );

  //
  static ThemeData dark = ThemeData.dark();
}

//
//
// BUTTON THEME
class AppButtonThemeData {
  AppButtonThemeData._();

  //
  static ElevatedButtonThemeData buttonThemeData =
      const ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      )),
      backgroundColor: WidgetStatePropertyAll(AppColors.white),
      foregroundColor: WidgetStatePropertyAll(AppColors.black),
    ),
  );
}

//
//
// TEXT THEME
class AppTextTheme {
  AppTextTheme._();

  static TextTheme appTextTheme = TextTheme(
    displayLarge: GoogleFonts.laila(fontSize: 57, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.laila(fontSize: 45, fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.laila(fontSize: 36, fontWeight: FontWeight.w600),
    headlineLarge: GoogleFonts.laila(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium:
        GoogleFonts.laila(fontSize: 28, fontWeight: FontWeight.w500),
    headlineSmall: GoogleFonts.laila(fontSize: 24, fontWeight: FontWeight.w500),
    titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.normal),
    labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w400),
  );
}

//
//
//
// TEXTFIELD THEME

class AppInputDecorationTheme {
  AppInputDecorationTheme._();

  //
  static InputDecorationTheme inputDecorationTheme = const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    labelStyle: TextStyle(color: AppColors.textLabel),
    floatingLabelStyle: TextStyle(color: AppColors.textLabel),
    hintStyle: TextStyle(color: AppColors.textLabel),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.textLabel),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.textLabel),
    ),
  );
}
