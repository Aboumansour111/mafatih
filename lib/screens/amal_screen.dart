import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/amal.dart';
import '../services/favorite_service.dart';
import '../services/font_size_service.dart';
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
  double fontSize = FontSizeService.defaultFontSize;

  static const double fontStep = 1;

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  // ==========================================================
  // اندازه فونت
  // ==========================================================

  Future<void> _loadFontSize() async {
    final savedSize = await FontSizeService.getAmalFontSize();

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

      await FontSizeService.setAmalFontSize(fontSize);
    }
  }

  Future<void> _decreaseFontSize() async {
    if (fontSize > FontSizeService.minFontSize) {
      setState(() {
        fontSize -= fontStep;
      });

      await FontSizeService.setAmalFontSize(fontSize);
    }
  }

  // ==========================================================
  // کپی متن عمل
  // ==========================================================

  String _buildCopyText() {
    final buffer = StringBuffer();

    buffer.writeln(widget.amal.title);

    if (widget.amal.source.trim().isNotEmpty) {
      buffer.writeln(widget.amal.source.trim());
    }

    buffer.writeln();

    for (var i = 0; i < widget.amal.sections.length; i++) {
      final section = widget.amal.sections[i];

      if (widget.amal.sections.length > 1) {
        buffer.writeln('بخش ${i + 1}');
        buffer.writeln();
      }

      if (section.arabic.trim().isNotEmpty) {
        buffer.writeln(section.arabic.trim());
      }

      if (section.translation.trim().isNotEmpty) {
        buffer.writeln();
        buffer.writeln('ترجمه:');
        buffer.writeln(section.translation.trim());
      }

      buffer.writeln();
    }

    return buffer.toString().trim();
  }

  Future<void> _copySectionText(AmalSection section, int index) async {
    final buffer = StringBuffer();

    if (widget.amal.sections.length > 1) {
      buffer.writeln('بخش ${index + 1}');
    }

    if (section.arabic.trim().isNotEmpty) {
      buffer.writeln(section.arabic.trim());
    }

    if (section.translation.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('ترجمه:');
      buffer.writeln(section.translation.trim());
    }

    final text = buffer.toString().trim();
    if (text.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'بخش با موفقیت کپی شد.',
          textDirection: TextDirection.rtl,
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _copyText() async {
    final text = _buildCopyText();

    if (text.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'متن عمل کپی شد.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
        ),
        duration: Duration(seconds: 2),
      ),
    );
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
          IconButton(
            tooltip: 'کپی متن',
            onPressed: _copyText,
            icon: const Icon(Icons.copy_rounded),
          ),

          FontSizeControls(
            onIncrease: _increaseFontSize,
            onDecrease: _decreaseFontSize,
            canIncrease: fontSize < FontSizeService.maxFontSize,
            canDecrease: fontSize > FontSizeService.minFontSize,
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

  // ==========================================================
  // بخش عمل
  // ==========================================================

  Widget _buildSection(
    AmalSection section,
    int index,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return GestureDetector(
      onLongPress: () => _copySectionText(section, index),
      child: Container(
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

              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),

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
      ),
    );
  }
}
