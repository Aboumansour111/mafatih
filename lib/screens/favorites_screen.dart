import 'package:flutter/material.dart';

import '../models/dua.dart';
import '../models/ziyarat.dart';
import '../services/content_service.dart';
import '../services/favorite_service.dart';
import '../widgets/theme_toggle_button.dart';
import 'dua_screen.dart';
import 'ziyarat_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final ContentService _contentService = ContentService();

  List<Dua> _favoriteDuas = [];
  List<Ziyarat> _favoriteZiyarats = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    try {
      final results = await Future.wait([
        _contentService.loadDuas(),
        _contentService.loadZiyarat(),
        _favoriteService.getFavorites(),
      ]);

      final duas = results[0] as List<Dua>;
      final ziyarats = results[1] as List<Ziyarat>;
      final favoriteIds = results[2] as Set<String>;

      final favoriteDuaIds = favoriteIds
          .where((id) => id.startsWith('dua:'))
          .map((id) => id.substring(4))
          .toSet();

      final favoriteZiyaratIds = favoriteIds
          .where((id) => id.startsWith('ziyarat:'))
          .map((id) => id.substring(8))
          .toSet();

      final favoriteDuas = duas
          .where((dua) => favoriteDuaIds.contains(dua.id))
          .toList();

      final favoriteZiyarats = ziyarats
          .where((ziyarat) => favoriteZiyaratIds.contains(ziyarat.id))
          .toList();

      if (!mounted) return;

      setState(() {
        _favoriteDuas = favoriteDuas;
        _favoriteZiyarats = favoriteZiyarats;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _favoriteDuas = [];
        _favoriteZiyarats = [];
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'خطا در بارگذاری علاقه‌مندی‌ها',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    }
  }

  Future<void> _removeDua(Dua dua) async {
    await _favoriteService.toggleDuaFavorite(dua.id);
    await _loadFavorites();
  }

  Future<void> _removeZiyarat(Ziyarat ziyarat) async {
    await _favoriteService.toggleZiyaratFavorite(ziyarat.id);
    await _loadFavorites();
  }

  Future<void> _openDua(Dua dua) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DuaScreen(dua: dua)),
    );

    await _loadFavorites();
  }

  Future<void> _openZiyarat(Ziyarat ziyarat) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ZiyaratScreen(ziyarat: ziyarat)),
    );

    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    final totalFavorites = _favoriteDuas.length + _favoriteZiyarats.length;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadFavorites,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
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
                                0.58,
                              ) ??
                              primary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.23),
                          blurRadius: 22,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: -38,
                          top: -38,
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
                          right: -40,
                          bottom: -55,
                          child: Container(
                            width: 120,
                            height: 120,
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
                                    color: Colors.white.withValues(alpha: 0.13),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.10,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.10,
                                      ),
                                    ),
                                  ),
                                  child: const ThemeToggleButton(),
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
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              totalFavorites == 0
                                  ? 'موارد مورد علاقه شما اینجا نمایش داده می‌شوند'
                                  : '$totalFavorites مورد ذخیره شده',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontSize: 13,
                                height: 1.8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              if (_loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (totalFavorites == 0)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
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
                            color: primary.withValues(alpha: 0.70),
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'هنوز موردی ذخیره نکرده‌اید',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'با لمس قلب کنار دعاها و زیارت‌ها،\n'
                          'آن‌ها را به علاقه‌مندی‌های خود اضافه کنید.',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                            height: 1.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                if (_favoriteDuas.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildSectionTitle(
                      context,
                      title: 'دعاها',
                      subtitle: '${_favoriteDuas.length} دعای ذخیره‌شده',
                      icon: Icons.auto_stories_rounded,
                    ),
                  ),

                if (_favoriteDuas.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final dua = _favoriteDuas[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildFavoriteCard(
                            context,
                            title: dua.title,
                            subtitle: 'دعا',
                            icon: Icons.auto_stories_rounded,
                            onTap: () => _openDua(dua),
                            onRemove: () => _removeDua(dua),
                          ),
                        );
                      }, childCount: _favoriteDuas.length),
                    ),
                  ),

                if (_favoriteZiyarats.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildSectionTitle(
                      context,
                      title: 'زیارت‌ها',
                      subtitle: '${_favoriteZiyarats.length} زیارت ذخیره‌شده',
                      icon: Icons.mosque_rounded,
                    ),
                  ),

                if (_favoriteZiyarats.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 35),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final ziyarat = _favoriteZiyarats[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildFavoriteCard(
                            context,
                            title: ziyarat.title,
                            subtitle: 'زیارت',
                            icon: Icons.mosque_rounded,
                            onTap: () => _openZiyarat(ziyarat),
                            onRemove: () => _removeZiyarat(ziyarat),
                          ),
                        );
                      }, childCount: _favoriteZiyarats.length),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 5,
            height: 28,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Icon(icon, color: primary, size: 19),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: primary, size: 23),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'حذف از علاقه‌مندی‌ها',
                onPressed: onRemove,
                icon: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.redAccent,
                  size: 23,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
