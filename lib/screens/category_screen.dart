import 'package:flutter/material.dart';

import '../models/amal.dart';
import '../models/category.dart';
import '../models/dua.dart';
import '../models/quran.dart';
import '../models/ziyarat.dart';
import '../services/content_service.dart';
import '../services/favorite_service.dart';
import '../utils/app_routes.dart';
import '../widgets/favorite_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'amal_screen.dart';
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

  String? _selectedSubcategory;

  @override
  Widget build(BuildContext context) {
    if (widget.category.id == 'favorite') {
      return _buildFavoriteScreen();
    }

    if (widget.category.id == 'duas') {
      return _buildDuasScreen();
    }

    if (widget.category.id == 'amal') {
      return _buildAmalScreen();
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

              final favoriteContent = allContent.where((item) {
                return favoriteIds.contains(_getContentFavoriteId(item));
              }).toList();

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
                      id: FavoriteService().duaId(item.id),
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

                  if (item is Amal) {
                    return _buildContentCard(
                      id: FavoriteService().amalId(item.id),
                      title: item.title,
                      icon: Icons.calendar_month_rounded,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          AppRoutes.slide(AmalScreen(amal: item)),
                        );

                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                  }

                  if (item is Ziyarat) {
                    return _buildContentCard(
                      id: FavoriteService().ziyaratId(item.id),
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
  // علاقه‌مندی‌ها
  // ==========================================================
  Future<Set<String>> _getFavoriteIds() async {
    final service = FavoriteService();

    return service.getFavorites();
  }

  // ==========================================================
  // بارگذاری تمام محتوا
  // ==========================================================
  Future<List<dynamic>> _loadAllContent() async {
    final duas = await _contentService.loadDuas();
    final amals = await _contentService.loadAmals();
    final ziyarat = await _contentService.loadZiyarat();
    final quran = await _contentService.loadQuran();

    return [...duas, ...amals, ...ziyarat, ...quran];
  }

  // ==========================================================
  // شناسه علاقه‌مندی
  // ==========================================================
  String _getContentFavoriteId(dynamic item) {
    final service = FavoriteService();

    if (item is Dua) {
      return service.duaId(item.id);
    }

    if (item is Amal) {
      return service.amalId(item.id);
    }

    if (item is Ziyarat) {
      return service.ziyaratId(item.id);
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
        leading: _selectedSubcategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () {
                  setState(() {
                    _selectedSubcategory = null;
                  });
                },
              )
            : null,
        title: Text(
          _selectedSubcategory == null
              ? widget.category.title
              : _getDuaSubcategoryTitle(_selectedSubcategory!),
        ),
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

          if (_selectedSubcategory == null) {
            return _buildDuaSubcategorySelection(categoryDuas);
          }

          final selectedDuas = _selectedSubcategory == ''
              ? categoryDuas.where((dua) => dua.subcategory.isEmpty).toList()
              : categoryDuas
                    .where((dua) => dua.subcategory == _selectedSubcategory)
                    .toList();

          return _buildDuaList(selectedDuas);
        },
      ),
    );
  }

  Widget _buildDuaSubcategorySelection(List<Dua> duas) {
    final subcategories = widget.category.subcategories;

    final hasUncategorized = duas.any((dua) => dua.subcategory.isEmpty);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...subcategories.map(
          (subcategory) => _buildSubcategoryCard(
            item: _SubcategoryItem(
              id: subcategory.id,
              title: subcategory.title,
              icon: _getSubcategoryIcon(subcategory.icon),
            ),
            onTap: () {
              setState(() {
                _selectedSubcategory = subcategory.id;
              });
            },
          ),
        ),
        if (hasUncategorized)
          _buildSubcategoryCard(
            item: const _SubcategoryItem(
              id: '',
              title: 'سایر دعاها',
              icon: Icons.more_horiz_rounded,
            ),
            onTap: () {
              setState(() {
                _selectedSubcategory = '';
              });
            },
          ),
      ],
    );
  }

  Widget _buildDuaList(List<Dua> duas) {
    if (duas.isEmpty) {
      return const Center(
        child: Text(
          'هنوز دعایی در این زیرمجموعه اضافه نشده است.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: duas.length,
      itemBuilder: (context, index) {
        final dua = duas[index];

        return _buildContentCard(
          id: FavoriteService().duaId(dua.id),
          title: dua.title,
          icon: Icons.auto_stories_rounded,
          onTap: () async {
            await Navigator.push(context, AppRoutes.slide(DuaScreen(dua: dua)));

            if (mounted) {
              setState(() {});
            }
          },
        );
      },
    );
  }

  String _getDuaSubcategoryTitle(String subcategory) {
    if (subcategory.isEmpty) {
      return 'سایر دعاها';
    }

    for (final item in widget.category.subcategories) {
      if (item.id == subcategory) {
        return item.title;
      }
    }

    return widget.category.title;
  }

  // ==========================================================
  // اعمال
  // ==========================================================
  Widget _buildAmalScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: _selectedSubcategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () {
                  setState(() {
                    _selectedSubcategory = null;
                  });
                },
              )
            : null,
        title: Text(
          _selectedSubcategory == null
              ? widget.category.title
              : _getAmalSubcategoryTitle(_selectedSubcategory!),
        ),
        centerTitle: true,
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: FutureBuilder<List<Amal>>(
        future: _contentService.loadAmals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'خطا در بارگذاری اعمال\n\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final amals = snapshot.data ?? [];

          final categoryAmals = amals
              .where((amal) => amal.category == widget.category.id)
              .toList();

          if (_selectedSubcategory == null) {
            return _buildAmalSubcategorySelection(categoryAmals);
          }

          final selectedAmals = _selectedSubcategory == ''
              ? categoryAmals.where((amal) => amal.subcategory.isEmpty).toList()
              : categoryAmals
                    .where((amal) => amal.subcategory == _selectedSubcategory)
                    .toList();

          return _buildAmalList(selectedAmals);
        },
      ),
    );
  }

  Widget _buildAmalSubcategorySelection(List<Amal> amals) {
    final subcategories = widget.category.subcategories;

    final hasUncategorized = amals.any((amal) => amal.subcategory.isEmpty);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...subcategories.map(
          (subcategory) => _buildSubcategoryCard(
            item: _SubcategoryItem(
              id: subcategory.id,
              title: subcategory.title,
              icon: _getSubcategoryIcon(subcategory.icon),
            ),
            onTap: () {
              setState(() {
                _selectedSubcategory = subcategory.id;
              });
            },
          ),
        ),
        if (hasUncategorized)
          _buildSubcategoryCard(
            item: const _SubcategoryItem(
              id: '',
              title: 'سایر اعمال',
              icon: Icons.more_horiz_rounded,
            ),
            onTap: () {
              setState(() {
                _selectedSubcategory = '';
              });
            },
          ),
      ],
    );
  }

  Widget _buildAmalList(List<Amal> amals) {
    if (amals.isEmpty) {
      return const Center(
        child: Text(
          'هنوز عملی در این زیرمجموعه اضافه نشده است.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: amals.length,
      itemBuilder: (context, index) {
        final amal = amals[index];

        return _buildContentCard(
          id: FavoriteService().amalId(amal.id),
          title: amal.title,
          icon: Icons.calendar_month_rounded,
          onTap: () async {
            await Navigator.push(
              context,
              AppRoutes.slide(AmalScreen(amal: amal)),
            );

            if (mounted) {
              setState(() {});
            }
          },
        );
      },
    );
  }

  String _getAmalSubcategoryTitle(String subcategory) {
    if (subcategory.isEmpty) {
      return 'سایر اعمال';
    }

    for (final item in widget.category.subcategories) {
      if (item.id == subcategory) {
        return item.title;
      }
    }

    return widget.category.title;
  }

  // ==========================================================
  // زیارات
  // ==========================================================
  Widget _buildZiyaratScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: _selectedSubcategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () {
                  setState(() {
                    _selectedSubcategory = null;
                  });
                },
              )
            : null,
        title: Text(
          _selectedSubcategory == null
              ? widget.category.title
              : _getZiyaratSubcategoryTitle(_selectedSubcategory!),
        ),
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

          if (_selectedSubcategory == null) {
            return _buildZiyaratSubcategorySelection(categoryZiyarat);
          }

          final selectedZiyarat = _selectedSubcategory == ''
              ? categoryZiyarat
                    .where((item) => item.subcategory.isEmpty)
                    .toList()
              : categoryZiyarat
                    .where((item) => item.subcategory == _selectedSubcategory)
                    .toList();

          return _buildZiyaratList(selectedZiyarat);
        },
      ),
    );
  }

  Widget _buildZiyaratSubcategorySelection(List<Ziyarat> ziyarat) {
    final subcategories = widget.category.subcategories;

    final hasUncategorized = ziyarat.any((item) => item.subcategory.isEmpty);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...subcategories.map(
          (subcategory) => _buildSubcategoryCard(
            item: _SubcategoryItem(
              id: subcategory.id,
              title: subcategory.title,
              icon: _getSubcategoryIcon(subcategory.icon),
            ),
            onTap: () {
              setState(() {
                _selectedSubcategory = subcategory.id;
              });
            },
          ),
        ),
        if (hasUncategorized)
          _buildSubcategoryCard(
            item: const _SubcategoryItem(
              id: '',
              title: 'سایر زیارات',
              icon: Icons.more_horiz_rounded,
            ),
            onTap: () {
              setState(() {
                _selectedSubcategory = '';
              });
            },
          ),
      ],
    );
  }

  Widget _buildZiyaratList(List<Ziyarat> ziyarat) {
    if (ziyarat.isEmpty) {
      return const Center(
        child: Text(
          'هنوز زیارتی در این زیرمجموعه اضافه نشده است.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ziyarat.length,
      itemBuilder: (context, index) {
        final item = ziyarat[index];

        return _buildContentCard(
          id: FavoriteService().ziyaratId(item.id),
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
  }

  String _getZiyaratSubcategoryTitle(String subcategory) {
    if (subcategory.isEmpty) {
      return 'سایر زیارات';
    }

    for (final item in widget.category.subcategories) {
      if (item.id == subcategory) {
        return item.title;
      }
    }

    return widget.category.title;
  }

  // ==========================================================
  // آیکون زیرمجموعه
  // ==========================================================
  IconData _getSubcategoryIcon(String icon) {
    switch (icon) {
      case 'auto_stories':
        return Icons.auto_stories_rounded;
      case 'today':
        return Icons.today_rounded;
      case 'event':
        return Icons.event_rounded;
      case 'volunteer_activism':
        return Icons.volunteer_activism_rounded;
      case 'person':
        return Icons.person_rounded;
      case 'view_week':
        return Icons.view_week_rounded;
      case 'calendar_month':
        return Icons.calendar_month_rounded;
      case 'mosque':
        return Icons.mosque_rounded;
      case 'groups':
        return Icons.groups_rounded;
      case 'more':
        return Icons.more_horiz_rounded;
      default:
        return Icons.auto_stories_rounded;
    }
  }

  // ==========================================================
  // کارت زیرمجموعه
  // ==========================================================
  Widget _buildSubcategoryCard({
    required _SubcategoryItem item,
    required VoidCallback onTap,
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
                child: Icon(item.icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  item.title,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_back_ios_rounded, size: 18, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // کارت محتوا
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

class _SubcategoryItem {
  final String id;
  final String title;
  final IconData icon;

  const _SubcategoryItem({
    required this.id,
    required this.title,
    required this.icon,
  });
}
