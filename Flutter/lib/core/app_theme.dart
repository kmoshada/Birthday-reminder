import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme(Color accent) {
    final primary = AppColors.coralPink;
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: AppColors.bgLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        elevation: 6,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withAlpha(242),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accent),
    );
  }

  static ThemeData darkTheme(Color accent) {
    final primary = AppColors.coralPink;
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        color: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accent),
    );
  }
}
