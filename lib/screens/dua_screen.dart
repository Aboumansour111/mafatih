import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/dua.dart';
import '../services/favorite_service.dart';
import '../services/font_size_service.dart';
import '../widgets/font_size_controls.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/favorite_button.dart';

class DuaScreen extends StatefulWidget {
  final Dua dua;

  const DuaScreen({super.key, required this.dua});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  double fontSize = FontSizeService.defaultFontSize;

  static const double fontStep = 1;

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final savedSize = await FontSizeService.getDuaFontSize();
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
      await FontSizeService.setDuaFontSize(fontSize);
    }
  }

  Future<void> _decreaseFontSize() async {
    if (fontSize > FontSizeService.minFontSize) {
      setState(() {
        fontSize -= fontStep;
      });
      await FontSizeService.setDuaFontSize(fontSize);
    }
  }

  String _buildCopyText() {
    final buffer = StringBuffer();
    buffer.writeln(widget.dua.title);
    buffer.writeln();

    for (var i = 0; i < widget.dua.sections.length; i++) {
      final section = widget.dua.sections[i];
      if (widget.dua.sections.length > 1) {
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

  Future<void> _copyText() async {
    final text = _buildCopyText();
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'متن با موفقیت کپی شد.',
          textDirection: TextDirection.rtl,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _copySectionText(DuaSection section, int index) async {
    final buffer = StringBuffer();
    if (widget.dua.sections.length > 1) {
      buffer.writeln('بخش ${index + 1}');
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
    final text = buffer.toString().trim();
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('بخش کپی شد.', textDirection: TextDirection.rtl),
        duration: Duration(seconds: 1),
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
          widget.dua.title,
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
          FavoriteButton(
            id: FavoriteService().duaId(widget.dua.id),
            size: 25,
            iconColor: Colors.white,
          ),
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
                  _buildHeroHeader(colorScheme, isDark),
                  const SizedBox(height: 22),
                  ...List.generate(widget.dua.sections.length, (index) {
                    return _buildSection(
                      widget.dua.sections[index],
                      index,
                      colorScheme,
                      isDark,
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(ColorScheme colorScheme, bool isDark) {
    return Container(
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
            color: colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.22),
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
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            widget.dua.title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.dua.sections.length} بخش',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    DuaSection section,
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
            if (widget.dua.sections.length > 1)
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
