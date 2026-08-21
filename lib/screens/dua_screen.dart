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

class _DuaScreenState extends State<DuaScreen> {
  bool showTranslation = true;
  bool isFavorite = false;

  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _loadFavorite();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? const Color(0xff0b2925) : Colors.white;

    const accent = Color(0xff39b9a4);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dua.title),
        centerTitle: true,

        actions: [
          IconButton(
            tooltip: 'علاقه‌مندی',
            onPressed: _toggleFavorite,

            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,

              color: isFavorite ? Colors.red : Colors.white,
            ),
          ),

          const ThemeToggleButton(),

          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // ==========================================================
            // کنترل نمایش ترجمه
            // ==========================================================

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              decoration: BoxDecoration(
                color: surfaceColor,

                borderRadius: BorderRadius.circular(16),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.05),

                    blurRadius: 10,

                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'نمایش ترجمه',

                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  Switch(
                    value: showTranslation,

                    onChanged: (value) {
                      setState(() {
                        showTranslation = value;
                      });
                    },

                    activeThumbColor: accent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==========================================================
            // بسم الله
            // ==========================================================
            const Text(
              'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ',

              textDirection: TextDirection.rtl,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
            ),

            const SizedBox(height: 25),

            // ==========================================================
            // متن دعا
            // ==========================================================
            ...widget.dua.sections.map((section) => _buildSection(section)),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // بخش دعا
  // ==========================================================

  Widget _buildSection(DuaSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xff00695c).withValues(alpha: 0.08),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          // ========================================================
          // متن عربی
          // ========================================================

          Text(
            section.arabic,

            textDirection: TextDirection.rtl,

            textAlign: TextAlign.justify,

            style: const TextStyle(
              fontSize: 22,
              height: 2.2,
              fontWeight: FontWeight.w500,
            ),
          ),

          // ========================================================
          // ترجمه
          // ========================================================
          if (showTranslation && section.translation.trim().isNotEmpty) ...[
            const SizedBox(height: 18),

            Divider(color: const Color(0xff39b9a4).withValues(alpha: 0.3)),

            const SizedBox(height: 14),

            Text(
              section.translation,

              textDirection: TextDirection.rtl,

              textAlign: TextAlign.justify,

              style: const TextStyle(fontSize: 17, height: 2),
            ),
          ],
        ],
      ),
    );
  }
}
