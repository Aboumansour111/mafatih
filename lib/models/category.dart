class Category {
  final String id;
  final String title;
  final String icon;
  final String type;

  Category({
    required this.id,
    required this.title,
    required this.icon,
    required this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
