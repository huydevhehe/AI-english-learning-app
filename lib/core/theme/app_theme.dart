import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F6FB),
    primaryColor: const Color(0xFF7B61FF),
    cardColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

 static final dark = ThemeData(
  brightness: Brightness.dark,

  // ✅ QUAN TRỌNG NHẤT – nền soft dark
  scaffoldBackgroundColor: const Color(0xFF18181B),

  // 🎴 card nổi hơn nền
  cardColor: const Color(0xFF1F1F23),

  primaryColor: const Color(0xFF7B61FF),
  dividerColor: const Color(0xFF2A2A2E),

  textTheme: const TextTheme(
    titleMedium: TextStyle(
      color: Color(0xFFEDEDED),
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFCCCCCC),
    ),
    bodySmall: TextStyle(
      color: Color(0xFF9E9E9E),
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF18181B),
    foregroundColor: Color(0xFFEDEDED),
    elevation: 0,
  ),
);

}
