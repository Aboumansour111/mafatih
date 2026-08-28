class ZiyaratSection {
  final String arabic;
  final String translation;
  final String? repeatLabel;

  ZiyaratSection({
    required this.arabic,
    required this.translation,
    this.repeatLabel,
  });

  factory ZiyaratSection.fromJson(Map<String, dynamic> json) {
    return ZiyaratSection(
      arabic: json['arabic'] ?? '',
      translation: json['translation'] ?? '',
      repeatLabel: json['repeatLabel'],
    );
  }
}

class Ziyarat {
  final String id;
  final String title;
  final String category;
  final List<ZiyaratSection> sections;

  Ziyarat({
    required this.id,
    required this.title,
    required this.category,
    required this.sections,
  });

  factory Ziyarat.fromJson(Map<String, dynamic> json) {
    return Ziyarat(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((item) => ZiyaratSection.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
