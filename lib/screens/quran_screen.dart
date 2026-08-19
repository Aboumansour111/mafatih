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
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark
        ? const Color(0xff0b2925)
        : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('قرآن کریم'),
        centerTitle: true,

        actions: const [
          ThemeToggleButton(),
          SizedBox(width: 8),
        ],
      ),

      body: FutureBuilder<List<QuranSurah>>(
        future: ContentService().loadQuran(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'خطا در بارگذاری قرآن\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final surahs = snapshot.data ?? [];

          if (surahs.isEmpty) {
            return const Center(
              child: Text(
                'هنوز سوره‌ای اضافه نشده است.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surahs.length,

            itemBuilder: (context, index) {
              final surah = surahs[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 15),

                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: InkWell(
                  borderRadius: BorderRadius.circular(22),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            QuranReaderScreen(surah: surah),
                      ),
                    );
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Row(
                      textDirection: TextDirection.rtl,

                      children: [
                        Container(
                          width: 52,
                          height: 52,

                          decoration: BoxDecoration(
                            color: const Color(0xff008f7a)
                                .withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                          ),

                          alignment: Alignment.center,

                          child: Text(
                            '${surah.number}',
                            style: const TextStyle(
                              color: Color(0xff39b9a4),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,

                            children: [
                              Text(
                                surah.name,
                                textDirection:
                                    TextDirection.rtl,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                '${surah.versesCount} آیه',
                                textDirection:
                                    TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? const Color(0xffa9bbb6)
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        FavoriteButton(
                          id: surah.id,
                          size: 27,
                        ),

                        const SizedBox(width: 4),

                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 18,
                          color: Color(0xff39b9a4),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}