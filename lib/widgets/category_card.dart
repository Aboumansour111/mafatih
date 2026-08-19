import 'package:flutter/material.dart';

import '../models/category.dart';
import '../screens/category_screen.dart';
import '../screens/quran_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    super.key,
    required this.category,
  });

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'dua':
        return Icons.auto_stories_rounded;

      case 'calendar':
        return Icons.calendar_month_rounded;

      case 'mosque':
        return Icons.mosque_rounded;

      case 'quran':
        return Icons.menu_book_rounded;

      case 'favorite':
        return Icons.favorite_rounded;

      default:
        return Icons.more_horiz_rounded;
    }
  }

  void _openCategory(BuildContext context) {
    if (category.id == 'quran') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const QuranScreen(),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ==========================================================
    // رنگ‌های کارت
    // ==========================================================

    final cardColor = isDark
        ? const Color(0xff0b2925)
        : Colors.white;

    final titleColor = isDark
        ? const Color(0xfff1f7f5)
        : const Color(0xff222222);

    final iconColor = isDark
        ? const Color(0xff4db6a5)
        : const Color(0xff00695c);

    final iconBackgroundColor = isDark
        ? const Color(0xff008f7a).withValues(alpha: 0.18)
        : const Color(0xff00695c).withValues(alpha: 0.10);

    // ==========================================================
    // کارت
    // ==========================================================

    return Container(
      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.28 : 0.06,
            ),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(24),

          onTap: () {
            _openCategory(context);
          },

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // ==================================================
                // آیکون
                // ==================================================

                Container(
                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    _getIcon(category.icon),
                    size: 35,
                    color: iconColor,
                  ),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // عنوان
                // ==================================================

                Text(
                  category.title,

                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}