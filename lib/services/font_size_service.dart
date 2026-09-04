import 'package:shared_preferences/shared_preferences.dart';

class FontSizeService {
  static const String _duaFontSizeKey = 'dua_font_size';
  static const String _quranFontSizeKey = 'quran_font_size';
  static const String _ziyaratFontSizeKey = 'ziyarat_font_size';
  static const String _amalFontSizeKey = 'amal_font_size';

  static const double defaultFontSize = 22;
  static const double minFontSize = 18;
  static const double maxFontSize = 30;

  static Future<double> _getSize(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? defaultFontSize;
  }

  static Future<void> _setSize(String key, double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, size);
  }

  // دعاها
  static Future<double> getDuaFontSize() => _getSize(_duaFontSizeKey);

  static Future<void> setDuaFontSize(double size) =>
      _setSize(_duaFontSizeKey, size);

  // قرآن
  static Future<double> getQuranFontSize() => _getSize(_quranFontSizeKey);

  static Future<void> setQuranFontSize(double size) =>
      _setSize(_quranFontSizeKey, size);

  // زیارات
  static Future<double> getZiyaratFontSize() => _getSize(_ziyaratFontSizeKey);

  static Future<void> setZiyaratFontSize(double size) =>
      _setSize(_ziyaratFontSizeKey, size);

  // اعمال
  static Future<double> getAmalFontSize() => _getSize(_amalFontSizeKey);

  static Future<void> setAmalFontSize(double size) =>
      _setSize(_amalFontSizeKey, size);
}
