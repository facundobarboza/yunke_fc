import 'package:flutter/material.dart';

class AppTheme {
  static const Color yunkeBlue = Color.fromRGBO(38, 53, 120, 1);
  static const Color yunkeRed = Color.fromRGBO(180, 15, 11, 1);
  static const Color yunkeRedLight = Color.fromRGBO(226, 10, 25, 1);
  static const Color yunkeWhite = Color.fromRGBO(255, 255, 255, 1);
  static const Color yunkeGray = Color.fromRGBO(224, 224, 224, 1);
  static const Color yunkeBackgroundGray = Color.fromRGBO(247, 246, 246, 1);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: yunkeBackgroundGray,
    primarySwatch: const MaterialColor(0xFF1565C0, {
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: yunkeBlue,
      600: Color(0xFF1976D2),
      700: Color(0xFF1565C0),
      800: Color(0xFF0D47A1),
      900: Color(0xFF0D47A1),
    }),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: yunkeBlue,
      foregroundColor: yunkeWhite,
      elevation: 2,
    ),
    cardTheme: const CardThemeData(
      color: yunkeWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: yunkeRed,
        foregroundColor: yunkeWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}