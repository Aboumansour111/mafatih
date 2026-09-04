import 'package:flutter/material.dart';

import '../models/quran.dart';
import '../services/font_size_service.dart';
import '../widgets/favorite_button.dart';
import '../widgets/font_size_controls.dart';
import '../widgets/theme_toggle_button.dart';

class QuranReaderScreen extends StatefulWidget {
  final QuranSurah surah;

  const QuranReaderScreen({
    super.key,
    required this.surah,
  });

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  bool showTranslation = true;
  double fontSize = FontSizeService.defaultFontSize;

  static const double fontStep = 1;

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final savedSize = await FontSizeService.getQuranFontSize();

    if (!mounted) return;

    setState(() {
      fontSize = savedSize;
    });
  }

  Future<void> _increaseFontSize() async {
    if (fontSize < FontSizeService.maxFontSize) {
      setState(() {
        fontSize += fontStep;
      });

      await FontSizeService.setQuranFontSize(fontSize);
    }
  }

  Future<void> _decreaseFontSize() async {
    if (fontSize > FontSizeService.minFontSize) {
      setState(() {
        fontSize -= fontStep;
      });

      await FontSizeService.setQuranFontSize(fontSize);
    }
  }

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
            // =========================================================
            // هدر
            // =========================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 16, 12, 20),
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
                                  ? const Color(0xff071d19)
                                  : const Color(0xff003f38),
                              0.62,
                            ) ??
                            primary,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.22),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: -45,
                        top: -45,
                        child: Container(
                          width: 135,
                          height: 135,
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
                          // =================================================
                          // دکمه‌های بالا
                          // =================================================
                          Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.13),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.10),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.menu_book_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const Spacer(),

                              // اندازه فونت
                              FontSizeControls(
                                onIncrease: _increaseFontSize,
                                onDecrease: _decreaseFontSize,
                                canIncrease: fontSize <
                                    FontSizeService.maxFontSize,
                                canDecrease: fontSize >
                                    FontSizeService.minFontSize,
                              ),

                              const SizedBox(width: 4),
                              FavoriteButton(
                                id: widget.surah.id,
                                size: 25,
                              ),
                              const SizedBox(width: 2),
                              const ThemeToggleButton(),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            widget.surah.name,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            widget.surah.arabicName,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.8,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              _buildHeaderChip(
                                icon: Icons.format_list_numbered_rounded,
                                text: '${widget.surah.versesCount} آیه',
                              ),
                              const SizedBox(width: 8),
                              _buildHeaderChip(
                                icon: Icons.auto_awesome_rounded,
                                text: 'قرآن کریم',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),

            // =========================================================
            // کنترل ترجمه
            // =========================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primary.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.translate_rounded,
                          color: primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'ترجمه آیات',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              showTranslation
                                  ? 'ترجمه نمایش داده می‌شود'
                                  : 'فقط متن عربی نمایش داده می‌شود',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: showTranslation,
                        onChanged: (value) {
                          setState(() {
                            showTranslation = value;
                          });
                        },
                        activeThumbColor: primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            // =========================================================
            // بسم الله
            // =========================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: primary.withValues(alpha: 0.20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: primary.withValues(alpha: 0.75),
                            size: 17,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: primary.withValues(alpha: 0.20),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: primary.withValues(alpha: 0.20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: primary.withValues(alpha: 0.75),
                            size: 17,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: primary.withValues(alpha: 0.20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            // =========================================================
            // آیات
            // =========================================================
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 35),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final verse = widget.surah.verses[index];
                    return _buildVerse(verse, index);
                  },
                  childCount: widget.surah.verses.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.09),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.85),
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerse(QuranVerse verse, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primary.withValues(
            alpha: isDark ? 0.10 : 0.07,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              left: -32,
              bottom: -32,
              child: Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primary.withValues(alpha: 0.05),
                    width: 2,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    verse.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: fontSize,
                      height: 2.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              primary.withValues(alpha: 0.20),
                              primary.withValues(alpha: 0.07),
                            ],
                          ),
                          border: Border.all(
                            color: primary.withValues(alpha: 0.15),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${verse.number}',
                          style: TextStyle(
                            color: primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Divider(
                          color: primary.withValues(alpha: 0.13),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'آیه',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  if (showTranslation &&
                      verse.translation.trim().isNotEmpty) ...[
                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.fromLTRB(
                        14,
                        13,
                        14,
                        13,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.045),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        verse.translation,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: fontSize * 0.70,
                          height: 2.05,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}