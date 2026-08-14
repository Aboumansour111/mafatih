import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/dua.dart';
import 'dua_screen.dart';
import '../services/content_service.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // دسته علاقه‌مندی‌ها فعلاً بعداً پیاده‌سازی می‌شود
    if (category.id == 'favorite') {
      return Scaffold(
        appBar: AppBar(title: Text(category.title), centerTitle: true),
        body: const Center(
          child: Text(
            'هنوز دعایی به علاقه‌مندی‌ها اضافه نشده است.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // فعلاً فقط ادعیه محتوا دارد
    if (category.id != 'duas') {
      return Scaffold(
        appBar: AppBar(title: Text(category.title), centerTitle: true),
        body: const Center(
          child: Text(
            'محتوای این بخش به‌زودی اضافه می‌شود.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // نمایش دعاها
    return Scaffold(
      appBar: AppBar(title: Text(category.title), centerTitle: true),

      body: FutureBuilder<List<Dua>>(
        future: ContentService().loadDuas(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'خطا در بارگذاری دعاها\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final duas = snapshot.data ?? [];

          final categoryDuas = duas
              .where((dua) => dua.category == category.id)
              .toList();

          if (categoryDuas.isEmpty) {
            return const Center(
              child: Text(
                'هنوز دعایی برای این بخش اضافه نشده است.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryDuas.length,

            itemBuilder: (context, index) {
              final dua = categoryDuas[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 15),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
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
                      MaterialPageRoute(builder: (_) => DuaScreen(dua: dua)),
                    );
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Row(
                      textDirection: TextDirection.rtl,

                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: const Color(0xff00695c).withValues(alpha: 0.12),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: Color(0xff00695c),
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,

                            children: [
                              Text(
                                dua.title,

                                textDirection: TextDirection.rtl,

                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'برای مطالعه دعا لمس کنید',

                                textDirection: TextDirection.rtl,

                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 18,
                          color: Color(0xff00695c),
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
