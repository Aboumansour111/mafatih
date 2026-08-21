import 'package:flutter/material.dart';

import '../models/category.dart';
import '../screens/category_screen.dart';
import '../screens/quran_screen.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        return Icons.auto_awesome_rounded;
    }
  }

  String _getSubtitle(String icon) {
    switch (icon) {
      case 'dua':
        return 'دعا و نیایش';

      case 'calendar':
        return 'اعمال و مناسبت‌ها';

      case 'mosque':
        return 'زیارات';

      case 'quran':
        return 'قرآن کریم';

      case 'favorite':
        return 'ذخیره‌شده‌ها';

      default:
        return 'مطالعه و نیایش';
    }
  }

  void _openCategory() {
    if (widget.category.id == 'quran') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuranScreen()),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(category: widget.category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    final primary = colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,

      builder: (context, child) {
        final scale = 1.0 - _controller.value;

        return Transform.scale(scale: scale, child: child);
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),

          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

            colors: isDark
                ? [
                    colorScheme.surfaceContainerHigh,
                    colorScheme.surfaceContainer,
                  ]
                : [Colors.white, const Color(0xfff4faf8)],
          ),

          border: Border.all(
            color: primary.withValues(alpha: isDark ? 0.18 : 0.08),
          ),

          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: isDark ? 0.10 : 0.07),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),

          child: Material(
            color: Colors.transparent,

            child: InkWell(
              onTap: _openCategory,

              onTapDown: (_) {
                _controller.forward();
              },

              onTapCancel: () {
                _controller.reverse();
              },

              onTapUp: (_) {
                _controller.reverse();
              },

              splashColor: primary.withValues(alpha: 0.10),
              highlightColor: primary.withValues(alpha: 0.04),

              child: Stack(
                children: [
                  // =================================================
                  // دایره‌های تزئینی
                  // =================================================

                  Positioned(
                    left: -28,
                    bottom: -28,

                    child: Container(
                      width: 105,
                      height: 105,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: primary.withValues(alpha: 0.06),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: -32,
                    top: -32,

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: primary.withValues(alpha: 0.025),
                      ),
                    ),
                  ),

                  // =================================================
                  // محتوای کارت
                  // =================================================
                  Padding(
                    padding: const EdgeInsets.all(17),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [
                        // =================================================
                        // آیکون
                        // =================================================

                        Align(
                          alignment: Alignment.centerRight,

                          child: Container(
                            width: 58,
                            height: 58,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),

                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,

                                colors: [
                                  primary.withValues(alpha: 0.18),
                                  primary.withValues(alpha: 0.07),
                                ],
                              ),

                              border: Border.all(
                                color: primary.withValues(alpha: 0.10),
                              ),
                            ),

                            child: Icon(
                              _getIcon(widget.category.icon),
                              size: 30,
                              color: primary,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // =================================================
                        // عنوان
                        // =================================================
                        Text(
                          widget.category.title,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // =================================================
                        // توضیح
                        // =================================================
                        Text(
                          _getSubtitle(widget.category.icon),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11.5,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // =================================================
                        // خط و فلش
                        // =================================================
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 3,

                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            const Spacer(),

                            Icon(
                              Icons.arrow_back_rounded,
                              size: 19,
                              color: primary.withValues(alpha: 0.75),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
