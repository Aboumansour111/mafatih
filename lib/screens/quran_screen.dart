import 'package:flutter/material.dart';

import '../models/quran.dart';
import '../services/content_service.dart';
import '../widgets/favorite_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'quran_reader_screen.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primary = colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            // =====================================================
            // هدر قرآن
            // =====================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),

                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 14, 22),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

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
                              0.55,
                            ) ??
                            primary,
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Stack(
                    children: [
                      // دایره تزئینی
                      Positioned(
                        left: -35,
                        top: -40,

                        child: Container(
                          width: 125,
                          height: 125,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 35,
                        bottom: -60,

                        child: Container(
                          width: 110,
                          height: 110,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,

                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),

                                child: const Icon(
                                  Icons.menu_book_rounded,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ),

                              const Spacer(),

                              const ThemeToggleButton(),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'قرآن کریم',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 29,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'آرامش دل، نور جان و راهنمای زندگی',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,

                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 14,
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

            // =====================================================
            // فاصله
            // =====================================================
            const SliverToBoxAdapter(child: SizedBox(height: 25)),

            // =====================================================
            // عنوان
            // =====================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

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
                          Text(
                            'سوره‌های قرآن',
                            textDirection: TextDirection.rtl,

                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            'سوره مورد نظر خود را برای مطالعه انتخاب کنید',
                            textDirection: TextDirection.rtl,

                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // =====================================================
            // لیست سوره‌ها
            // =====================================================
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),

              sliver: FutureBuilder<List<QuranSurah>>(
                future: ContentService().loadQuran(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),

                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(22),

                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(22),

                          border: Border.all(color: colorScheme.outlineVariant),
                        ),

                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 42,
                              color: colorScheme.error,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'خطا در بارگذاری قرآن',
                              textDirection: TextDirection.rtl,

                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              '${snapshot.error}',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final surahs = snapshot.data ?? [];

                  if (surahs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 70),

                        child: Column(
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 58,
                              color: primary.withValues(alpha: 0.45),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              'هنوز سوره‌ای اضافه نشده است.',
                              textDirection: TextDirection.rtl,

                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final surah = surahs[index];

                      return _SurahCard(
                        surah: surah,
                        primary: primary,
                        colorScheme: colorScheme,
                        isDark: isDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuranReaderScreen(surah: surah),
                            ),
                          );
                        },
                      );
                    }, childCount: surahs.length),
                  );
                },
              ),
            ),

            // =====================================================
            // پایین صفحه
            // =====================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),

                child: Text(
                  'وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا',

                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// کارت سوره
// =============================================================

class _SurahCard extends StatefulWidget {
  final QuranSurah surah;
  final Color primary;
  final ColorScheme colorScheme;
  final bool isDark;
  final VoidCallback onTap;

  const _SurahCard({
    required this.surah,
    required this.primary,
    required this.colorScheme,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<_SurahCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 0.025,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.primary;
    final colorScheme = widget.colorScheme;

    return AnimatedBuilder(
      animation: _controller,

      builder: (context, child) {
        return Transform.scale(scale: 1 - _controller.value, child: child);
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 13),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

            colors: widget.isDark
                ? [
                    colorScheme.surfaceContainerHigh,
                    colorScheme.surfaceContainer,
                  ]
                : [Colors.white, const Color(0xfff4faf8)],
          ),

          border: Border.all(
            color: primary.withValues(alpha: widget.isDark ? 0.16 : 0.07),
          ),

          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: widget.isDark ? 0.08 : 0.055),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),

          child: Material(
            color: Colors.transparent,

            child: InkWell(
              onTap: widget.onTap,

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

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Row(
                  textDirection: TextDirection.rtl,

                  children: [
                    // =================================================
                    // شماره سوره
                    // =================================================

                    Container(
                      width: 58,
                      height: 58,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),

                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,

                          colors: [
                            primary.withValues(alpha: 0.18),
                            primary.withValues(alpha: 0.06),
                          ],
                        ),

                        border: Border.all(
                          color: primary.withValues(alpha: 0.12),
                        ),
                      ),

                      child: Stack(
                        alignment: Alignment.center,

                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 42,
                            color: primary.withValues(alpha: 0.08),
                          ),

                          Text(
                            '${widget.surah.number}',

                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // =================================================
                    // اطلاعات سوره
                    // =================================================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          Text(
                            widget.surah.name,

                            textDirection: TextDirection.rtl,

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              Text(
                                '${widget.surah.versesCount} آیه',

                                textDirection: TextDirection.rtl,

                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(width: 7),

                              Container(
                                width: 4,
                                height: 4,

                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),

                              const SizedBox(width: 7),

                              Text(
                                'سوره',

                                textDirection: TextDirection.rtl,

                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Container(
                            height: 3,
                            width: 38,

                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // =================================================
                    // علاقه‌مندی
                    // =================================================
                    FavoriteButton(id: widget.surah.id, size: 25),

                    const SizedBox(width: 2),

                    // =================================================
                    // فلش
                    // =================================================
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: primary.withValues(alpha: 0.75),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
