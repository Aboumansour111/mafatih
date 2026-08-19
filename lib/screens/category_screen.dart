import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/dua.dart';
import '../models/quran.dart';
import '../models/ziyarat.dart';
import '../services/content_service.dart';
import '../services/favorite_service.dart';
import '../utils/app_routes.dart';
import '../widgets/favorite_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'dua_screen.dart';
import 'quran_reader_screen.dart';
import 'ziyarat_screen.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ContentService _contentService = ContentService();

  @override
  Widget build(BuildContext context) {
    if (widget.category.id == 'favorite') {
      return _buildFavoriteScreen();
    }

    if (widget.category.id == 'duas') {
      return _buildDuasScreen();
    }

    if (widget.category.id == 'ziyarat') {
      return _buildZiyaratScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: const Center(
        child: Text(
          'محتوای این بخش به‌زودی اضافه می‌شود.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // ==========================================================
  // علاقه‌مندی‌ها
  // ==========================================================

  Widget _buildFavoriteScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),

      body: FutureBuilder<List<dynamic>>(
        future: _loadAllContent(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'خطا در بارگذاری علاقه‌مندی‌ها\n\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final allContent = snapshot.data ?? [];

          return FutureBuilder<Set<String>>(
            future: _getFavoriteIds(),

            builder: (context, favoriteSnapshot) {
              if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (favoriteSnapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'خطا در بارگذاری علاقه‌مندی‌ها\n\n'
                      '${favoriteSnapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final favoriteIds = favoriteSnapshot.data ?? <String>{};

              final favoriteContent = allContent
                  .where((item) => favoriteIds.contains(_getContentId(item)))
                  .toList();

              if (favoriteContent.isEmpty) {
                return const Center(
                  child: Text(
                    'هنوز محتوایی به علاقه‌مندی‌ها اضافه نشده است.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteContent.length,

                itemBuilder: (context, index) {
                  final item = favoriteContent[index];

                  if (item is Dua) {
                    return _buildContentCard(
                      id: item.id,
                      title: item.title,
                      icon: Icons.auto_stories_rounded,

                      onTap: () async {
                        await Navigator.push(
                          context,
                          AppRoutes.slide(DuaScreen(dua: item)),
                        );

                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                  }

                  if (item is Ziyarat) {
                    return _buildContentCard(
                      id: item.id,
                      title: item.title,
                      icon: Icons.mosque_rounded,

                      onTap: () async {
                        await Navigator.push(
                          context,
                          AppRoutes.slide(ZiyaratScreen(ziyarat: item)),
                        );

                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                  }

                  if (item is QuranSurah) {
                    return _buildContentCard(
                      id: item.id,
                      title: item.name,
                      icon: Icons.menu_book_rounded,
                      subtitle: '${item.versesCount} آیه',

                      onTap: () async {
                        await Navigator.push(
                          context,
                          AppRoutes.slide(QuranReaderScreen(surah: item)),
                        );

                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }

  // ==========================================================
  // دریافت علاقه‌مندی‌ها
  // ==========================================================

  Future<Set<String>> _getFavoriteIds() async {
    final service = await FavoriteServiceHelper.create();

    return service;
  }

  // ==========================================================
  // بارگذاری تمام محتوا
  // ==========================================================

  Future<List<dynamic>> _loadAllContent() async {
    final duas = await _contentService.loadDuas();
    final ziyarat = await _contentService.loadZiyarat();
    final quran = await _contentService.loadQuran();

    return [...duas, ...ziyarat, ...quran];
  }

  // ==========================================================
  // شناسه محتوا
  // ==========================================================

  String _getContentId(dynamic item) {
    if (item is Dua) {
      return item.id;
    }

    if (item is Ziyarat) {
      return item.id;
    }

    if (item is QuranSurah) {
      return item.id;
    }

    return '';
  }

  // ==========================================================
  // ادعیه
  // ==========================================================

  Widget _buildDuasScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),

      body: FutureBuilder<List<Dua>>(
        future: _contentService.loadDuas(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'خطا در بارگذاری دعاها\n\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final duas = snapshot.data ?? [];

          final categoryDuas = duas
              .where((dua) => dua.category == widget.category.id)
              .toList();

          if (categoryDuas.isEmpty) {
            return const Center(
              child: Text(
                'هنوز دعایی برای این بخش اضافه نشده است.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryDuas.length,

            itemBuilder: (context, index) {
              final dua = categoryDuas[index];

              return _buildContentCard(
                id: dua.id,
                title: dua.title,
                icon: Icons.auto_stories_rounded,

                onTap: () async {
                  await Navigator.push(
                    context,
                    AppRoutes.slide(DuaScreen(dua: dua)),
                  );

                  if (mounted) {
                    setState(() {});
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  // ==========================================================
  // زیارات
  // ==========================================================

  Widget _buildZiyaratScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),

      body: FutureBuilder<List<Ziyarat>>(
        future: _contentService.loadZiyarat(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'خطا در بارگذاری زیارات\n\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final ziyarat = snapshot.data ?? [];

          final categoryZiyarat = ziyarat
              .where((item) => item.category == widget.category.id)
              .toList();

          if (categoryZiyarat.isEmpty) {
            return const Center(
              child: Text(
                'هنوز زیارتی برای این بخش اضافه نشده است.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryZiyarat.length,

            itemBuilder: (context, index) {
              final item = categoryZiyarat[index];

              return _buildContentCard(
                id: item.id,
                title: item.title,
                icon: Icons.mosque_rounded,

                onTap: () async {
                  await Navigator.push(
                    context,
                    AppRoutes.slide(ZiyaratScreen(ziyarat: item)),
                  );

                  if (mounted) {
                    setState(() {});
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  // ==========================================================
  // کارت مشترک
  // ==========================================================

  Widget _buildContentCard({
    required String id,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String subtitle = 'برای مطالعه لمس کنید',
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xff0b2925) : Colors.white;

    final iconColor = isDark
        ? const Color(0xff39b9a4)
        : const Color(0xff00695c);

    final iconBackground = isDark
        ? const Color(0xff008f7a).withValues(alpha: 0.18)
        : const Color(0xff00695c).withValues(alpha: 0.12);

    final subtitleColor = isDark ? const Color(0xffa9bbb6) : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Row(
            textDirection: TextDirection.rtl,

            children: [
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),

                child: Icon(icon, color: iconColor, size: 28),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      title,
                      textDirection: TextDirection.rtl,

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,
                      textDirection: TextDirection.rtl,

                      style: TextStyle(fontSize: 13, color: subtitleColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              FavoriteButton(id: id, size: 27),

              const SizedBox(width: 4),

              Icon(Icons.arrow_back_ios_rounded, size: 18, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// دسترسی ساده به FavoriteService
// ==========================================================

class FavoriteServiceHelper {
  static Future<Set<String>> create() async {
    final service = FavoriteService();

    return service.getFavorites();
  }
}
