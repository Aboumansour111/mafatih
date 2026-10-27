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
  bool showTranslation = true;
  double fontSize = FontSizeService.defaultFontSize;

  static const double fontStep = 1;

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

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

  String _buildCopyText() {
    final buffer = StringBuffer();
    buffer.writeln(widget.amal.title);
    if (widget.amal.source.trim().isNotEmpty) {
      buffer.writeln(widget.amal.source.trim());
    }
    buffer.writeln();

    for (var i = 0; i < widget.amal.sections.length; i++) {
      final section = widget.amal.sections[i];
      if (section.arabic.trim().isNotEmpty) {
        buffer.writeln(section.arabic.trim());
      }
      if (showTranslation && section.translation.trim().isNotEmpty) {
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

  Future<void> _copySectionText(AmalSection section, int index) async {
    final buffer = StringBuffer();
    if (section.arabic.trim().isNotEmpty) {
      buffer.writeln(section.arabic.trim());
    }
    if (showTranslation && section.translation.trim().isNotEmpty) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          tooltip: 'بازگشت',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const SizedBox.shrink(),
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
            id: FavoriteService().amalId(widget.amal.id),
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
                  // کنترل نمایش ترجمه
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      showTranslation ? Icons.translate : Icons.translate_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'ترجمه',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            showTranslation
                                ? 'ترجمه نمایش داده می‌شود'
                                : 'ترجمه مخفی است',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),

            ...List.generate(widget.amal.sections.length, (index) {
                    return _buildSection(
                      widget.amal.sections[index],
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
              widget.amal.source.trim(),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
    final hasRepeat = (section.repeatLabel ?? '').trim().isNotEmpty;
    final hasArabic = section.arabic.trim().isNotEmpty;
    final hasTranslation =
        showTranslation && section.translation.trim().isNotEmpty;

    return GestureDetector(
      onLongPress: () => _copySectionText(section, index),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
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
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // نوار باریک تأکیدی (در RTL سمت راست متن قرار می‌گیرد)
              Container(
                width: 3.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withValues(alpha: isDark ? 0.85 : 0.75),
                      colorScheme.tertiary.withValues(alpha: isDark ? 0.55 : 0.45),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (hasRepeat)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary.withValues(
                                      alpha: isDark ? 0.28 : 0.16,
                                    ),
                                    colorScheme.tertiary.withValues(
                                      alpha: isDark ? 0.22 : 0.12,
                                    ),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(alpha: 0.35),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withValues(alpha: 0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.repeat_rounded,
                                    size: 16,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    section.repeatLabel!.trim(),
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (hasArabic)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(
                              alpha: isDark ? 0.09 : 0.055,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
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
                        ),
                      if (hasArabic && hasTranslation)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (hasTranslation)
                        const SizedBox(height: 4),
                      if (hasTranslation)
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
