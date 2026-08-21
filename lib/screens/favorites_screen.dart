import 'package:flutter/material.dart';

import '../models/dua.dart';
import '../models/quran.dart';
import '../models/ziyarat.dart';
import '../services/content_service.dart';
import '../services/favorite_service.dart';
import 'dua_screen.dart';
import 'quran_reader_screen.dart';
import 'ziyarat_screen.dart';

enum _FavoriteType { dua, ziyarat, quran }

class _FavoriteItem {
  final String id;
  final String title;
  final String subtitle;
  final _FavoriteType type;
  final dynamic data;

  const _FavoriteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.data,
  });
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ContentService _contentService = ContentService();
  final FavoriteService _favoriteService = FavoriteService();

  List<_FavoriteItem> _items = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _loading = true;
    });

    try {
      final results = await Future.wait([
        _contentService.loadDuas(),
        _contentService.loadZiyarat(),
        _contentService.loadQuran(),
        _favoriteService.getFavorites(),
      ]);

      final duas = results[0] as List<Dua>;
      final ziyarat = results[1] as List<Ziyarat>;
      final quran = results[2] as List<QuranSurah>;
      final favoriteIds = results[3] as Set<String>;

      final items = <_FavoriteItem>[];

      // ==========================================================
      // دعاها
      // ==========================================================

      for (final dua in duas) {
        final id = _favoriteService.duaId(dua.id);

        if (favoriteIds.contains(id)) {
          items.add(
            _FavoriteItem(
              id: id,
              title: dua.title,
              subtitle: 'دعا',
              type: _FavoriteType.dua,
              data: dua,
            ),
          );
        }
      }

      // ==========================================================
      // زیارت‌ها
      // ==========================================================

      for (final item in ziyarat) {
        final id = _favoriteService.ziyaratId(item.id);

        if (favoriteIds.contains(id)) {
          items.add(
            _FavoriteItem(
              id: id,
              title: item.title,
              subtitle: 'زیارت',
              type: _FavoriteType.ziyarat,
              data: item,
            ),
          );
        }
      }

      // ==========================================================
      // قرآن
      // ==========================================================

      for (final surah in quran) {
        final id = surah.id;

        if (favoriteIds.contains(id)) {
          items.add(
            _FavoriteItem(
              id: id,
              title: surah.name,
              subtitle: 'قرآن کریم • سوره ${surah.number}',
              type: _FavoriteType.quran,
              data: surah,
            ),
          );
        }
      }

      if (!mounted) return;

      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _items = [];
        _loading = false;
      });
    }
  }

  Future<void> _removeFavorite(_FavoriteItem item) async {
    await _favoriteService.toggle(item.id);

    if (!mounted) return;

    setState(() {
      _items.removeWhere((element) => element.id == item.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'از علاقه‌مندی‌ها حذف شد',
          textDirection: TextDirection.rtl,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openItem(_FavoriteItem item) {
    late final Widget page;

    switch (item.type) {
      case _FavoriteType.dua:
        page = DuaScreen(dua: item.data as Dua);
        break;

      case _FavoriteType.ziyarat:
        page = ZiyaratScreen(ziyarat: item.data as Ziyarat);
        break;

      case _FavoriteType.quran:
        page = QuranReaderScreen(surah: item.data as QuranSurah);
        break;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) {
      _loadFavorites();
    });
  }

  IconData _getIcon(_FavoriteType type) {
    switch (type) {
      case _FavoriteType.dua:
        return Icons.auto_stories_rounded;

      case _FavoriteType.ziyarat:
        return Icons.mosque_rounded;

      case _FavoriteType.quran:
        return Icons.menu_book_rounded;
    }
  }

  String _getEmptyTitle() {
    return 'هنوز چیزی ذخیره نکرده‌اید';
  }

  String _getEmptySubtitle() {
    return 'دعاها، زیارت‌ها و سوره‌های مورد علاقه‌تان را\n'
        'با لمس قلب ذخیره کنید تا اینجا نمایش داده شوند.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ========================================================
            // هدر
            // ========================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 16, 14, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        primary,
                        Color.lerp(
                              primary,
                              isDark
                                  ? const Color(0xff061814)
                                  : const Color(0xff003f38),
                              0.60,
                            ) ??
                            primary,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.22),
                        blurRadius: 22,
                        offset: const Offset(0, 9),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // دایره تزئینی

                      Positioned(
                        left: -40,
                        top: -40,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.07),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        right: -35,
                        bottom: -45,
                        child: Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.035),
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.10),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),

                              const Spacer(),

                              IconButton(
                                tooltip: 'بازگشت',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'علاقه‌مندی‌ها',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            'مطالبی که برای دسترسی سریع ذخیره کرده‌اید',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ========================================================
            // محتوا
            // ========================================================
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(context, colorScheme, primary),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = _items[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildFavoriteCard(
                        context,
                        item,
                        colorScheme,
                        primary,
                      ),
                    );
                  }, childCount: _items.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    Color primary,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                color: primary.withValues(alpha: 0.75),
                size: 46,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              _getEmptyTitle(),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              _getEmptySubtitle(),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    _FavoriteItem item,
    ColorScheme colorScheme,
    Color primary,
  ) {
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _openItem(item),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.035),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(_getIcon(item.type), color: primary, size: 27),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.title,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      item.subtitle,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 7),

              IconButton(
                tooltip: 'حذف از علاقه‌مندی‌ها',
                onPressed: () => _removeFavorite(item),
                icon: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.redAccent,
                  size: 23,
                ),
              ),

              Icon(
                Icons.arrow_back_ios_rounded,
                size: 16,
                color: primary.withValues(alpha: 0.65),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
