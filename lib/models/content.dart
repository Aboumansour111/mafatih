class Content {
  final String id;
  final String title;
  final String category;

  final String arabicText;
  final String translation;

  final String source;

  final bool favorite;

  Content({
    required this.id,
    required this.title,
    required this.category,

    required this.arabicText,
    required this.translation,

    required this.source,

    required this.favorite,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],

      title: json['title'],

      category: json['category'],

      arabicText: json['arabicText'] ?? '',

      translation: json['translation'] ?? '',

      source: json['source'] ?? '',

      favorite: json['favorite'] ?? false,
    );
  }
}
