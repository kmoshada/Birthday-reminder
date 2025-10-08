import 'package:flutter/material.dart';

class AppColors {
  static const coralPink = Color(0xFFFF6B81);
  static const honeyYellow = Color(0xFFFFD166);
  static const violetIndigo = Color(0xFF6C63FF);
  static const bgLight = Color(0xFFFFF9F7);
  static const text = Color(0xFF2E2E2E);
  static const secondaryText = Color(0xFF757575);

  // helper gradient
  static LinearGradient vibrantGradient(Color accent) => LinearGradient(
    colors: [coralPink, violetIndigo, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
