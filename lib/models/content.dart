class ContentSection {
  final String arabic;
  final String translation;

  ContentSection({required this.arabic, required this.translation});

  factory ContentSection.fromJson(Map<String, dynamic> json) {
    return ContentSection(
      arabic: json['arabic'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}

class Content {
  final String id;
  final String title;
  final String category;
  final String type;
  final List<ContentSection> sections;
  final String source;

  Content({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.sections,
    required this.source,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((item) => ContentSection.fromJson(item))
          .toList(),
      source: json['source'] ?? '',
    );
  }
}
