import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorite_ids';

  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList(_key) ?? [];

    return favorites.toSet();
  }

  // ==========================================================
  // شناسه‌های یکتا
  // ==========================================================

  String duaId(String id) {
    return 'dua:$id';
  }

  String ziyaratId(String id) {
    return 'ziyarat:$id';
  }

  String amalId(String id) {
    return 'amal:$id';
  }

  // ==========================================================
  // بررسی علاقه‌مندی
  // ==========================================================

  Future<bool> isDuaFavorite(String id) async {
    final favorites = await getFavorites();

    return favorites.contains(duaId(id));
  }

  Future<bool> isZiyaratFavorite(String id) async {
    final favorites = await getFavorites();

    return favorites.contains(ziyaratId(id));
  }

  Future<bool> isAmalFavorite(String id) async {
    final favorites = await getFavorites();

    return favorites.contains(amalId(id));
  }

  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();

    return favorites.contains(id);
  }

  // ==========================================================
  // تغییر وضعیت علاقه‌مندی
  // ==========================================================

  Future<bool> toggleDuaFavorite(String id) async {
    return toggle(duaId(id));
  }

  Future<bool> toggleZiyaratFavorite(String id) async {
    return toggle(ziyaratId(id));
  }

  Future<bool> toggleAmalFavorite(String id) async {
    return toggle(amalId(id));
  }

  Future<bool> toggleFavorite(String id) async {
    return toggle(id);
  }

  // ==========================================================
  // تغییر وضعیت
  // ==========================================================

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
