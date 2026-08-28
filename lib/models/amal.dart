class AmalSection {
  final String arabic;
  final String translation;

  AmalSection({required this.arabic, required this.translation});

  factory AmalSection.fromJson(Map<String, dynamic> json) {
    return AmalSection(
      arabic: json['arabic'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}

class Amal {
  final String id;
  final String title;
  final String category;
  final String type;
  final List<AmalSection> sections;
  final String source;

  Amal({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.sections,
    required this.source,
  });

  factory Amal.fromJson(Map<String, dynamic> json) {
    return Amal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((item) => AmalSection.fromJson(item))
          .toList(),
      source: json['source'] ?? '',
    );
  }
}
