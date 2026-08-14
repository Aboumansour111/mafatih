import 'package:flutter/material.dart';

import '../models/category.dart';
import '../screens/category_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  IconData _getIcon(String icon) {
    switch (icon) {
      case "dua":
        return Icons.auto_stories_rounded;

      case "calendar":
        return Icons.calendar_month_rounded;

      case "mosque":
        return Icons.mosque_rounded;

      case "quran":
        return Icons.menu_book_rounded;

      case "favorite":
        return Icons.favorite_rounded;

      default:
        return Icons.more_horiz_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),

            blurRadius: 15,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(24),

        onTap: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) => CategoryScreen(category: category),
            ),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: const Color(0xff00695c).withOpacity(0.1),

                  shape: BoxShape.circle,
                ),

                child: Icon(
                  _getIcon(category.icon),

                  size: 35,

                  color: const Color(0xff00695c),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                category.title,

                style: const TextStyle(
                  fontSize: 16,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
