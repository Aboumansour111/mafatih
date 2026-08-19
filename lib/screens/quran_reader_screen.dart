import 'package:flutter/material.dart';

import '../models/quran.dart';
import '../widgets/favorite_button.dart';
import '../widgets/theme_toggle_button.dart';

class QuranReaderScreen extends StatefulWidget {
  final QuranSurah surah;

  const QuranReaderScreen({super.key, required this.surah});

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  bool showTranslation = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? const Color(0xff0b2925) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.name),
        centerTitle: true,

        actions: [
          FavoriteButton(id: widget.surah.id, size: 25),

          const ThemeToggleButton(),

          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Text(
              widget.surah.arabicName,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
            ),

            const SizedBox(height: 15),

            Container(
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

              child: SwitchListTile(
                value: showTranslation,

                onChanged: (value) {
                  setState(() {
                    showTranslation = value;
                  });
                },

                title: const Text(
                  'نمایش ترجمه',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                secondary: const Icon(
                  Icons.translate_rounded,
                  color: Color(0xff39b9a4),
                ),

                activeThumbColor: const Color(0xff39b9a4),
              ),
            ),

            const SizedBox(height: 25),

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

            ...widget.surah.verses.map((verse) => _buildVerse(verse)),
          ],
        ),
      ),
    );
  }

  Widget _buildVerse(QuranVerse verse) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xff00695c).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Text(
            verse.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 23,
              height: 2.3,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,

            child: Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: const Color(0xff008f7a).withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),

              alignment: Alignment.center,

              child: Text(
                '${verse.number}',
                style: const TextStyle(
                  color: Color(0xff39b9a4),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          if (showTranslation && verse.translation.trim().isNotEmpty) ...[
            const SizedBox(height: 15),

            Divider(color: const Color(0xff39b9a4).withValues(alpha: 0.3)),

            const SizedBox(height: 12),

            Text(
              verse.translation,
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
