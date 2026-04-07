import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ── Dark Theme ─────────────────────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.purpleAccent,
    cardColor: const Color(0xFF1A1A1A),
    canvasColor: const Color(0xFF1A1A1A),
    dividerColor: const Color(0xFF2A2A2A),
    hintColor: Colors.white38,
    colorScheme: const ColorScheme.dark(
      primary: Colors.purpleAccent,
      secondary: Colors.pinkAccent,
      surface: Color(0xFF1A1A1A),
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF1A1A1A),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF1A1A1A),
    ),
  );

  // ── Light Theme ────────────────────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF2F2F7),
    primaryColor: Colors.purpleAccent,
    cardColor: Colors.white,
    canvasColor: Colors.white,
    dividerColor: const Color(0xFFE0E0E0),
    hintColor: Colors.black38,
    colorScheme: const ColorScheme.light(
      primary: Colors.purpleAccent,
      secondary: Colors.pinkAccent,
      surface: Colors.white,
      onSurface: Color(0xFF1C1C1E),
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1C1C1E),
      iconTheme: IconThemeData(color: Color(0xFF1C1C1E)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF1C1C1E)),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
    ),
  );
}
