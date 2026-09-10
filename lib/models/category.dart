class CategorySubcategory {
  final String id;
  final String title;
  final String icon;

  CategorySubcategory({
    required this.id,
    required this.title,
    required this.icon,
  });

  factory CategorySubcategory.fromJson(Map<String, dynamic> json) {
    return CategorySubcategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? 'more',
    );
  }
}

class Category {
  final String id;
  final String title;
  final String icon;
  final String type;
  final List<CategorySubcategory> subcategories;

  Category({
    required this.id,
    required this.title,
    required this.icon,
    required this.type,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      type: json['type'] ?? '',
      subcategories: (json['subcategories'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                CategorySubcategory.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
