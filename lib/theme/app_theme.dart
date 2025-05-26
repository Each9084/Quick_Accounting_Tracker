import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.lightText),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.lightPrimary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkText),
    ),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(
      secondary: AppColors.darkPrimary,
    ),
  );
}
