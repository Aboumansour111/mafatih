import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorite_ids';

  /// دریافت تمام شناسه‌های علاقه‌مندی
  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList(_key) ?? [];

    return favorites.toSet();
  }

  /// شناسه یکتا برای دعا
  String duaId(String id) {
    return 'dua:$id';
  }

  /// شناسه یکتا برای زیارت
  String ziyaratId(String id) {
    return 'ziyarat:$id';
  }

  /// بررسی علاقه‌مندی دعا
  Future<bool> isDuaFavorite(String id) async {
    final favorites = await getFavorites();

    return favorites.contains(duaId(id));
  }

  /// بررسی علاقه‌مندی زیارت
  Future<bool> isZiyaratFavorite(String id) async {
    final favorites = await getFavorites();

    return favorites.contains(ziyaratId(id));
  }

  /// تغییر وضعیت علاقه‌مندی دعا
  Future<bool> toggleDuaFavorite(String id) async {
    return toggle(duaId(id));
  }

  /// تغییر وضعیت علاقه‌مندی زیارت
  Future<bool> toggleZiyaratFavorite(String id) async {
    return toggle(ziyaratId(id));
  }

  /// متد سازگار با کد فعلی برنامه
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();

    return favorites.contains(id);
  }

  /// متد سازگار با کد فعلی برنامه
  Future<bool> toggleFavorite(String id) async {
    return toggle(id);
  }

  /// تغییر وضعیت یک شناسه
  Future<bool> toggle(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList(_key) ?? [];

    if (favorites.contains(id)) {
      favorites.remove(id);

      await prefs.setStringList(_key, favorites);

      return false;
    }

    favorites.add(id);

    await prefs.setStringList(_key, favorites);

    return true;
  }
}
