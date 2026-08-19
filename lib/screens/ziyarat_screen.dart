import 'package:flutter/material.dart';

import '../models/ziyarat.dart';
import '../services/favorite_service.dart';

class ZiyaratScreen extends StatefulWidget {
  final Ziyarat ziyarat;

  const ZiyaratScreen({super.key, required this.ziyarat});

  @override
  State<ZiyaratScreen> createState() => _ZiyaratScreenState();
}

class _ZiyaratScreenState extends State<ZiyaratScreen> {
  bool showTranslation = true;
  bool isFavorite = false;

  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final result = await _favoriteService.isFavorite(widget.ziyarat.id);

    if (mounted) {
      setState(() {
        isFavorite = result;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final result = await _favoriteService.toggleFavorite(widget.ziyarat.id);

    if (mounted) {
      setState(() {
        isFavorite = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ziyarat.title),
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
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
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

            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                  color: Color(0xff00695c),
                ),

                activeThumbColor: const Color(0xff00695c),
              ),
            ),

            const SizedBox(height: 25),

            ...widget.ziyarat.sections.map((section) => _buildSection(section)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ZiyaratSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xff00695c).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
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

          if (showTranslation && section.translation.trim().isNotEmpty) ...[
            const SizedBox(height: 15),

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
