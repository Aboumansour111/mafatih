import 'package:flutter/material.dart';

import '../models/category.dart';
import '../services/content_service.dart';
import '../widgets/category_card.dart';
import '../widgets/theme_toggle_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مفاتیح یمانی'),
        centerTitle: true,

        actions: const [ThemeToggleButton()],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: FutureBuilder<List<Category>>(
          future: ContentService().loadCategories(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'خطا در بارگذاری دسته‌بندی‌ها\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final categories = snapshot.data ?? [];

            return GridView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: categories.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.05,
              ),

              itemBuilder: (context, index) {
                return CategoryCard(category: categories[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
