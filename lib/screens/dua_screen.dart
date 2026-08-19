import 'package:flutter/material.dart';

import '../models/dua.dart';

class DuaScreen extends StatefulWidget {
  final Dua dua;

  const DuaScreen({super.key, required this.dua});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  bool showTranslation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dua.title), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // کنترل نمایش ترجمه
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              decoration: BoxDecoration(
                color: const Color(0xff00695c).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // بسم الله الرحمن الرحیم
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

            // فرازهای دعا
            ...widget.dua.sections.map((section) => _buildSection(section)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(DuaSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xff00695c).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          // متن عربی
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

          // ترجمه
          if (showTranslation && section.translation.trim().isNotEmpty) ...[
            const SizedBox(height: 18),

            Divider(color: const Color(0xff00695c).withValues(alpha: 0.2)),

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
