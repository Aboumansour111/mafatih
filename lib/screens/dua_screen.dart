import 'package:flutter/material.dart';

import '../models/dua.dart';
import '../services/favorite_service.dart';
import '../widgets/theme_toggle_button.dart';

class DuaScreen extends StatefulWidget {
  final Dua dua;

  const DuaScreen({super.key, required this.dua});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen>
    with SingleTickerProviderStateMixin {
  bool showTranslation = true;
  bool isFavorite = false;

  final FavoriteService _favoriteService = FavoriteService();

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _animationController.forward();

    _loadFavorite();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorite() async {
    final result = await _favoriteService.isFavorite(widget.dua.id);

    if (mounted) {
      setState(() {
        isFavorite = result;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final result = await _favoriteService.toggleFavorite(widget.dua.id);

    if (mounted) {
      setState(() {
        isFavorite = result;
      });
    }
  }

  void _toggleTranslation(bool value) {
    setState(() {
      showTranslation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final background = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        title: Text(
          widget.dua.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        centerTitle: true,

        actions: [
          _FavoriteButton(isFavorite: isFavorite, onPressed: _toggleFavorite),

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
                  _buildHeroHeader(context, colorScheme, isDark),

                  const SizedBox(height: 18),

                  _buildTranslationControl(context, colorScheme),

                  const SizedBox(height: 28),

                  _buildBismillah(context, colorScheme),

                  const SizedBox(height: 30),

                  ...List.generate(widget.dua.sections.length, (index) {
                    final section = widget.dua.sections[index];

                    return _buildSection(
                      context,
                      section,
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

  // ==========================================================
  // هدر اصلی
  // ==========================================================

  Widget _buildHeroHeader(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(22, 24, 22, 25),

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
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 2,
                ),
              ),
            ),
          ),

          Positioned(
            right: -35,
            bottom: -50,

            child: Container(
              width: 115,
              height: 115,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.white.withValues(alpha: 0.035),
              ),
            ),
          ),

          Column(
            children: [
              Container(
                width: 62,
                height: 62,

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),

                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),

              const SizedBox(height: 17),

              Text(
                widget.dua.title,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,

                maxLines: 3,
                overflow: TextOverflow.ellipsis,

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
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // کنترل ترجمه
  // ==========================================================

  Widget _buildTranslationControl(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),

      decoration: BoxDecoration(
        color: colorScheme.surface,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        textDirection: TextDirection.rtl,

        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              Icons.translate_rounded,
              color: colorScheme.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text(
                  'ترجمه فارسی',
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
                      ? 'ترجمه در حال نمایش است'
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

          const SizedBox(width: 8),

          Switch(value: showTranslation, onChanged: _toggleTranslation),
        ],
      ),
    );
  }

  // ==========================================================
  // بسم الله
  // ==========================================================

  Widget _buildBismillah(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: colorScheme.primary.withValues(alpha: 0.16),
              ),
            ),

            const SizedBox(width: 12),

            Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: colorScheme.primary.withValues(alpha: 0.75),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Container(
                height: 1,
                color: colorScheme.primary.withValues(alpha: 0.16),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Text(
          'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,

          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 23,
            fontWeight: FontWeight.w700,
            height: 2,
          ),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: colorScheme.primary.withValues(alpha: 0.16),
              ),
            ),

            const SizedBox(width: 12),

            Icon(
              Icons.auto_awesome_rounded,
              size: 12,
              color: colorScheme.primary.withValues(alpha: 0.55),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Container(
                height: 1,
                color: colorScheme.primary.withValues(alpha: 0.16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // بخش دعا
  // ==========================================================

  Widget _buildSection(
    BuildContext context,
    DuaSection section,
    int index,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final hasTranslation =
        showTranslation && section.translation.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Container(
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

        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              // ----------------------------------------------
              // نوار بالای کارت
              // ----------------------------------------------

              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),

                color: colorScheme.primary.withValues(
                  alpha: isDark ? 0.07 : 0.045,
                ),

                child: Row(
                  textDirection: TextDirection.rtl,

                  children: [
                    Container(
                      width: 32,
                      height: 32,

                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),

                      alignment: Alignment.center,

                      child: Text(
                        '${index + 1}',

                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 9),

                    Text(
                      'بخش ${index + 1}',
                      textDirection: TextDirection.rtl,

                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    Icon(
                      Icons.menu_book_rounded,
                      size: 17,
                      color: colorScheme.primary.withValues(alpha: 0.65),
                    ),
                  ],
                ),
              ),

              // ----------------------------------------------
              // متن عربی
              // ----------------------------------------------
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),

                child: Text(
                  section.arabic,

                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,

                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 22,
                    height: 2.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // ----------------------------------------------
              // ترجمه
              // ----------------------------------------------
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),

                crossFadeState: hasTranslation
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,

                firstChild: const SizedBox.shrink(),

                secondChild: Container(
                  margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),

                  padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),

                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(
                      alpha: isDark ? 0.07 : 0.055,
                    ),

                    borderRadius: BorderRadius.circular(19),

                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.08),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      Row(
                        textDirection: TextDirection.rtl,

                        children: [
                          Icon(
                            Icons.translate_rounded,
                            size: 17,
                            color: colorScheme.primary,
                          ),

                          const SizedBox(width: 7),

                          Text(
                            'ترجمه',
                            textDirection: TextDirection.rtl,

                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 11),

                      Text(
                        section.translation,

                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,

                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 16.5,
                          height: 2.05,
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

// ==========================================================
// دکمه علاقه‌مندی
// ==========================================================

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isFavorite ? 'حذف از علاقه‌مندی‌ها' : 'افزودن به علاقه‌مندی‌ها',

      onPressed: onPressed,

      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),

        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },

        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,

          key: ValueKey(isFavorite),

          color: isFavorite ? Colors.redAccent : Colors.white,

          size: 25,
        ),
      ),
    );
  }
}
