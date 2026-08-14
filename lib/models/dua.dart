class Dua {
  final String id;
  final String title;
  final String category;
  final String arabic;
  final String translation;

  Dua({
    required this.id,
    required this.title,
    required this.category,
    required this.arabic,
    required this.translation,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      arabic: json['arabic'],
      translation: json['translation'],
    );
  }
}
