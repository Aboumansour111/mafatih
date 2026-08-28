import 'package:flutter/material.dart';

import '../models/amal.dart';
import '../services/favorite_service.dart';
import '../widgets/font_size_controls.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/favorite_button.dart';

class AmalScreen extends StatefulWidget {
  final Amal amal;

  const AmalScreen({super.key, required this.amal});

  @override
  State<AmalScreen> createState() => _AmalScreenState();
}

class _AmalScreenState extends State<AmalScreen> {
  double fontSize = 22;

  static const double minFontSize = 17;
  static const double maxFontSize = 32;
  static const double fontStep = 1;

  void _increaseFontSize() {
    if (fontSize < maxFontSize) {
      setState(() {
        fontSize += fontStep;
      });
    }
  }

  void _decreaseFontSize() {
    if (fontSize > minFontSize) {
      setState(() {
        fontSize -= fontStep;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.amal.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          FontSizeControls(
            onIncrease: _increaseFontSize,
            onDecrease: _decreaseFontSize,
            canIncrease: fontSize < maxFontSize,
            canDecrease: fontSize > minFontSize,
          ),

          const SizedBox(width: 4),

          FavoriteButton(
            id: FavoriteService().amalId(widget.amal.id),
            size: 27,
          ),

          const SizedBox(width: 4),

          const ThemeToggleButton(),

          const SizedBox(width: 8),
        ],
      ),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 35),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  // =====================================================
                  // هدر
                  // =====================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          colorScheme.primary,
                          Color.lerp(
                                colorScheme.primary,
                                colorScheme.surface,
                                isDark ? 0.35 : 0.15,
                              ) ??
                              colorScheme.primary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(
                            alpha: isDark ? 0.18 : 0.22,
                          ),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),

                        const SizedBox(height: 17),

                        Text(
                          widget.amal.title,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.6,
                          ),
                        ),

                        if (widget.amal.source.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.amal.source,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =====================================================
                  // بخش‌های عمل
                  // =====================================================
                  if (widget.amal.sections.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 70),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 55,
                            color: colorScheme.primary.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'محتوایی برای نمایش وجود ندارد.',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...widget.amal.sections.asMap().entries.map((entry) {
                      final index = entry.key;
                      final section = entry.value;

                      return _buildSection(section, index, colorScheme, isDark);
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    AmalSection section,
    int index,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(
              alpha: isDark ? 0.045 : 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.amal.sections.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'بخش ${index + 1}',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (section.arabic.trim().isNotEmpty)
            Text(
              section.arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: fontSize,
                height: 2.35,
                fontWeight: FontWeight.w500,
              ),
            ),

          if (section.translation.trim().isNotEmpty) ...[
            const SizedBox(height: 22),

            Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),

            const SizedBox(height: 18),

            Text(
              section.translation,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: fontSize - 3,
                height: 2.1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
