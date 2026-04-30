import 'package:flutter/material.dart';

class AppColors {
  static const greenDark = Color(0xFF355E3B);
  static const greenMid = Color(0xFF4D7A51);
  static const greenLight = Color(0xFFEAF3EA);

  static const blue = Color(0xFF2F66F3);
  static const background = Color(0xFFF6F7F8);
  static const card = Colors.white;
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const amber = Color(0xFFF6B52E);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.greenDark,
        primary: AppColors.greenDark,
        secondary: AppColors.blue,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.greenDark,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
  color: AppColors.card,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.greenDark,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}