class QuranVerse {
  final int number;
  final String arabic;
  final String translation;

  QuranVerse({
    required this.number,
    required this.arabic,
    required this.translation,
  });

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      number: json['number'] ?? 0,
      arabic: json['arabic'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}

class QuranSurah {
  final int number;
  final String name;
  final String arabicName;
  final int versesCount;
  final List<QuranVerse> verses;

  QuranSurah({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.versesCount,
    required this.verses,
  });

  /// شناسه یکتای سوره برای علاقه‌مندی‌ها
  String get id => 'quran_$number';

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      versesCount: json['versesCount'] ?? 0,
      verses: (json['verses'] as List<dynamic>? ?? [])
          .map((item) => QuranVerse.fromJson(item))
          .toList(),
    );
  }
}
