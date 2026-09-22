class AmalSection {
  final String arabic;
  final String translation;
  final String? repeatLabel;

  AmalSection({
    required this.arabic,
    required this.translation,
    this.repeatLabel,
  });

  factory AmalSection.fromJson(Map<String, dynamic> json) {
    return AmalSection(
      arabic: json['arabic'] ?? '',
      translation: json['translation'] ?? '',
      repeatLabel: json['repeatLabel'] as String?,
    );
  }
}

class Amal {
  final String id;
  final String title;
  final String category;
  final String subcategory;
  final String type;
  final List<AmalSection> sections;
  final String source;
  final String sourceUrl;
  final String status;

  Amal({
    required this.id,
    required this.title,
    required this.category,
    required this.subcategory,
    required this.type,
    required this.sections,
    required this.source,
    this.sourceUrl = '',
    this.status = '',
  });

  factory Amal.fromJson(Map<String, dynamic> json) {
    return Amal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      type: json['type'] ?? '',
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((item) => AmalSection.fromJson(item as Map<String, dynamic>))
          .toList(),
      source: json['source'] ?? '',
      sourceUrl: json['source_url'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
