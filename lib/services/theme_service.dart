import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'dark_mode';
  static const String _fontKey = 'app_font';

  bool _isDarkMode = false;

  String _fontFamily = 'Vazirmatn';

  bool get isDarkMode => _isDarkMode;

  String get fontFamily => _fontFamily;

  ThemeService();

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool(_themeKey) ?? false;

    _fontFamily = prefs.getString(_fontKey) ?? 'Vazirmatn';

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_themeKey, _isDarkMode);
  }

  Future<void> setFont(String fontFamily) async {
    _fontFamily = fontFamily;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_fontKey, fontFamily);
  }
}
