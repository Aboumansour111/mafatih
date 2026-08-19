import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/dua.dart';
import '../models/ziyarat.dart';
import '../services/content_service.dart';
import '../services/favorite_service.dart';
import 'dua_screen.dart';
import 'ziyarat_screen.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ContentService _contentService = ContentService();
  final FavoriteService _favoriteService = FavoriteService();

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
      appBar: AppBar(title: Text(widget.category.title), centerTitle: true),
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
      appBar: AppBar(title: Text(widget.category.title), centerTitle: true),
      body: FutureBuilder<Set<String>>(
        future: _favoriteService.getFavorites(),
        builder: (context, favoriteSnapshot) {
          if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoriteSnapshot.hasError) {
            return Center(
              child: Text(
                'خطا در بارگذاری علاقه‌مندی‌ها\n\n'
                '${favoriteSnapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final favoriteIds = favoriteSnapshot.data ?? <String>{};

          if (favoriteIds.isEmpty) {
            return const Center(
              child: Text(
                'هنوز محتوایی به علاقه‌مندی‌ها اضافه نشده است.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return FutureBuilder<List<dynamic>>(
            future: _loadAllContent(),
            builder: (context, contentSnapshot) {
              if (contentSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (contentSnapshot.hasError) {
                return Center(
                  child: Text(
                    'خطا در بارگذاری محتوا\n\n'
                    '${contentSnapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final allContent = contentSnapshot.data ?? [];

              final favoriteContent = allContent
                  .where((item) => favoriteIds.contains(_getContentId(item)))
                  .toList();

              if (favoriteContent.isEmpty) {
                return const Center(
                  child: Text(
                    'محتوای ذخیره‌شده پیدا نشد.',
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
                      context: context,
                      id: item.id,
                      title: item.title,
                      icon: Icons.auto_stories_rounded,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DuaScreen(dua: item),
                          ),
                        );

                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                  }

                  if (item is Ziyarat) {
                    return _buildContentCard(
                      context: context,
                      id: item.id,
                      title: item.title,
                      icon: Icons.mosque_rounded,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ZiyaratScreen(ziyarat: item),
                          ),
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

  Future<List<dynamic>> _loadAllContent() async {
    final duas = await _contentService.loadDuas();
    final ziyarat = await _contentService.loadZiyarat();

    return [...duas, ...ziyarat];
  }

  String _getContentId(dynamic item) {
    if (item is Dua) {
      return item.id;
    }

    if (item is Ziyarat) {
      return item.id;
    }

    return '';
  }

  // ==========================================================
  // ادعیه
  // ==========================================================

  Widget _buildDuasScreen() {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.title), centerTitle: true),
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
                context: context,
                id: dua.id,
                title: dua.title,
                icon: Icons.auto_stories_rounded,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DuaScreen(dua: dua)),
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
      appBar: AppBar(title: Text(widget.category.title), centerTitle: true),
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
                context: context,
                id: item.id,
                title: item.title,
                icon: Icons.mosque_rounded,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ZiyaratScreen(ziyarat: item),
                    ),
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
    required BuildContext context,
    required String id,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
              // آیکون محتوا
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff00695c).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xff00695c), size: 28),
              ),

              const SizedBox(width: 15),

              // عنوان
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
                    const Text(
                      'برای مطالعه لمس کنید',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // قلب
              FutureBuilder<bool>(
                future: _favoriteService.isFavorite(id),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;

                  return IconButton(
                    tooltip: isFavorite
                        ? 'حذف از علاقه‌مندی‌ها'
                        : 'افزودن به علاقه‌مندی‌ها',
                    onPressed: () async {
                      await _favoriteService.toggleFavorite(id);

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 27,
                    ),
                  );
                },
              ),

              // فلش
              const Icon(
                Icons.arrow_back_ios_rounded,
                size: 18,
                color: Color(0xff00695c),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
