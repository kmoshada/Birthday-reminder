import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  Color _accent = const Color(0xFFFFD166); // Default accent color

  bool get isDark => _isDark;
  Color get accent => _accent;

  ThemeProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    final accentValue = prefs.getInt('accentColor') ?? 0xFFFFD166;
    _accent = Color(accentValue);
    notifyListeners();
  }

  Future<void> toggleDark(bool value) async {
    _isDark = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', value);
  }

  Future<void> setAccent(Color c) async {
    _accent = c;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', c.value);
  }

  ThemeData get themeData {
    final brightness = _isDark ? Brightness.dark : Brightness.light;

    final scheme = ColorScheme.fromSeed(
      seedColor: _accent,
      brightness: brightness,
    );

    // ✅ build ThemeData with forced colorScheme
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(scheme.primary),
        trackColor: WidgetStateProperty.all(scheme.primaryContainer),
      ),
    );
  }
}
