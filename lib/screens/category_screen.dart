import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/dua.dart';
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

              return Card(
                margin: const EdgeInsets.only(bottom: 10),

                child: ListTile(
                  title: Text(dua.title, textDirection: TextDirection.rtl),

                  trailing: const Icon(Icons.arrow_back_ios_rounded, size: 18),

                  onTap: () {
                    // صفحه نمایش متن دعا را بعداً اینجا باز می‌کنیم
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
