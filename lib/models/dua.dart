class DuaSection {
  final String arabic;
  final String translation;
  final String? repeatLabel;

  DuaSection({
    required this.arabic,
    required this.translation,
    this.repeatLabel,
  });

  factory DuaSection.fromJson(Map<String, dynamic> json) {
    return DuaSection(
      arabic: (json['arabic'] ?? '').toString(),
      translation: (json['translation'] ?? '').toString(),
      repeatLabel: json['repeatLabel']?.toString(),
    );
  }
}

class Dua {
  final String id;
  final String title;
  final String category;
  final String subcategory;
  final List<DuaSection> sections;

  Dua({
    required this.id,
    required this.title,
    required this.category,
    required this.subcategory,
    required this.sections,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    final sectionsData = json['sections'];
    final List<DuaSection> sections;

    if (sectionsData is List) {
      sections = sectionsData
          .whereType<Map<String, dynamic>>()
          .map(DuaSection.fromJson)
          .toList();
    } else {
      final arabic = (json['arabic'] ?? '').toString();
      final translation = (json['translation'] ?? '').toString();
      sections = _createSections(
        arabic: arabic,
        translation: translation,
      );
    }

    return Dua(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? 'دعای بدون عنوان').toString(),
      // برخی رکوردهای واردشده از کانال category ندارند؛
      // آن‌ها را به‌صورت پیش‌فرض در دسته ادعیه قرار می‌دهیم.
      category: (json['category'] ?? 'duas').toString(),
      subcategory: (json['subcategory'] ?? '').toString(),
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

    const maxArabicCharacters = 180;
    final arabicParts = _splitText(arabic, maxArabicCharacters);

    if (arabicParts.isEmpty) {
      return [];
    }

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
