class DuaSection {
  final String arabic;
  final String translation;

  DuaSection({required this.arabic, required this.translation});

  factory DuaSection.fromJson(Map<String, dynamic> json) {
    return DuaSection(
      arabic: json['arabic'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}

class Dua {
  final String id;
  final String title;
  final String category;
  final List<DuaSection> sections;

  Dua({
    required this.id,
    required this.title,
    required this.category,
    required this.sections,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    // اگر بعداً دعایی sections آماده داشته باشد،
    // مستقیماً همان را استفاده می‌کنیم.
    if (json['sections'] != null) {
      return Dua(
        id: json['id'],
        title: json['title'],
        category: json['category'],
        sections: (json['sections'] as List<dynamic>)
            .map((item) => DuaSection.fromJson(item))
            .toList(),
      );
    }

    // برای دعاهای فعلی که arabic و translation کامل دارند،
    // به صورت خودکار فرازبندی می‌کنیم.
    final arabic = json['arabic'] ?? '';
    final translation = json['translation'] ?? '';

    final sections = _createSections(arabic: arabic, translation: translation);

    return Dua(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      sections: sections,
    );
  }

  static List<DuaSection> _createSections({
    required String arabic,
    required String translation,
  }) {
    if (arabic.trim().isEmpty) {
      return [];
    }

    // تقریباً معادل چند خط نمایش روی موبایل.
    const maxArabicCharacters = 180;

    final arabicParts = _splitText(arabic, maxArabicCharacters);

    if (arabicParts.isEmpty) {
      return [];
    }

    // ترجمه را به همان تعداد بخش تقسیم می‌کنیم
    // تا هر بخش عربی یک ترجمه متناظر داشته باشد.
    final translationParts = _splitIntoParts(translation, arabicParts.length);

    return List.generate(
      arabicParts.length,
      (index) => DuaSection(
        arabic: arabicParts[index],
        translation: index < translationParts.length
            ? translationParts[index]
            : '',
      ),
    );
  }

  static List<String> _splitText(String text, int maxCharacters) {
    final result = <String>[];

    String remaining = text.trim();

    while (remaining.isNotEmpty) {
      if (remaining.length <= maxCharacters) {
        result.add(remaining);
        break;
      }

      int splitIndex = remaining.lastIndexOf(' ', maxCharacters);

      if (splitIndex <= 0) {
        splitIndex = maxCharacters;
      }

      result.add(remaining.substring(0, splitIndex).trim());

      remaining = remaining.substring(splitIndex).trim();
    }

    return result;
  }

  static List<String> _splitIntoParts(String text, int partCount) {
    if (text.trim().isEmpty || partCount <= 0) {
      return [];
    }

    final remaining = text.trim();

    if (partCount == 1) {
      return [remaining];
    }

    final result = <String>[];
    int start = 0;

    for (int i = 0; i < partCount; i++) {
      if (i == partCount - 1) {
        result.add(remaining.substring(start).trim());
        break;
      }

      final target = (remaining.length * (i + 1)) ~/ partCount;

      int splitIndex = remaining.indexOf(' ', target);

      if (splitIndex == -1) {
        splitIndex = target;
      }

      result.add(remaining.substring(start, splitIndex).trim());

      start = splitIndex;
    }

    return result;
  }
}
