import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFFDFAF7);
  static const Color textPrimary = Color(0xFF3D3D3D);
  static const Color textSecondary = Color(0xFF6B7280); 
  static const Color textDark = Color(0xFF4A1C17);
  
  static const Color primaryAction = Color(0xFFA44D3E);
  static const Color primaryActionLight = Color(0xFFFDEEE9);
  
  static const Color logBackground = Color(0xFFF3EFF8);
  static const Color logIconBackground = Color(0xFF7C58C0);
  static const Color logBorder = Color(0xFFE8E0F3);

  static const Color insightBackground = Color(0xFFFEF3F1);
  
  static const Color cardShadow = Color(0x08000000);
  
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: primaryAction,
      fontFamily: 'Plus Jakarta Sans',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFF111827), fontSize: 30, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textDark, fontSize: 24, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      ),
    );
  }
}
