import 'package:flutter/material.dart';

import '../models/dua.dart';
import '../models/quran.dart';
import '../models/ziyarat.dart';
import '../services/content_service.dart';
import 'dua_screen.dart';
import 'quran_reader_screen.dart';
import 'ziyarat_screen.dart';

enum SearchMode { titleOnly, titleAndContent }

enum SearchResultType { dua, ziyarat, quran }

class SearchResult {
  final String title;
  final String subtitle;
  final SearchResultType type;
  final dynamic data;

  SearchResult({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.data,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ContentService _contentService = ContentService();

  SearchMode _mode = SearchMode.titleOnly;

  List<Dua> _duas = [];
  List<Ziyarat> _ziyarats = [];
  List<QuranSurah> _quran = [];

  List<SearchResult> _results = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    try {
      final results = await Future.wait([
        _contentService.loadDuas(),
        _contentService.loadZiyarat(),
        _contentService.loadQuran(),
      ]);

      if (!mounted) return;

      setState(() {
        _duas = results[0] as List<Dua>;
        _ziyarats = results[1] as List<Ziyarat>;
        _quran = results[2] as List<QuranSurah>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  String _normalize(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll('ي', 'ی')
        .replaceAll('ى', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('ة', 'ه')
        .replaceAll('ۀ', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll('\u200c', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  bool _contains(String text, String query) {
    return _normalize(text).contains(_normalize(query));
  }

  void _search(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    final results = <SearchResult>[];

    // ============================================================
    // دعاها
    // ============================================================

    for (final dua in _duas) {
      bool matched = _contains(dua.title, query);

      if (_mode == SearchMode.titleAndContent && !matched) {
        for (final section in dua.sections) {
          if (_contains(section.arabic, query) ||
              _contains(section.translation, query)) {
            matched = true;
            break;
          }
        }
      }

      if (matched) {
        results.add(
          SearchResult(
            title: dua.title,
            subtitle: 'دعا',
            type: SearchResultType.dua,
            data: dua,
          ),
        );
      }
    }

    // ============================================================
    // زیارت‌ها
    // ============================================================

    for (final ziyarat in _ziyarats) {
      bool matched = _contains(ziyarat.title, query);

      if (_mode == SearchMode.titleAndContent && !matched) {
        for (final section in ziyarat.sections) {
          if (_contains(section.arabic, query) ||
              _contains(section.translation, query)) {
            matched = true;
            break;
          }
        }
      }

      if (matched) {
        results.add(
          SearchResult(
            title: ziyarat.title,
            subtitle: 'زیارت',
            type: SearchResultType.ziyarat,
            data: ziyarat,
          ),
        );
      }
    }

    // ============================================================
    // قرآن
    // ============================================================

    for (final surah in _quran) {
      bool matched =
          _contains(surah.name, query) || _contains(surah.arabicName, query);

      if (_mode == SearchMode.titleAndContent && !matched) {
        for (final verse in surah.verses) {
          if (_contains(verse.arabic, query) ||
              _contains(verse.translation, query)) {
            matched = true;
            break;
          }
        }
      }

      if (matched) {
        results.add(
          SearchResult(
            title: surah.name,
            subtitle: 'قرآن کریم • سوره ${surah.number}',
            type: SearchResultType.quran,
            data: surah,
          ),
        );
      }
    }

    setState(() {
      _results = results;
    });
  }

  void _changeSearchMode(SearchMode mode) {
    setState(() {
      _mode = mode;
    });

    if (_controller.text.trim().isNotEmpty) {
      _search(_controller.text);
    }
  }

  void _clearSearch() {
    _controller.clear();

    setState(() {
      _results = [];
    });
  }

  void _openResult(SearchResult result) {
    Widget page;

    switch (result.type) {
      case SearchResultType.dua:
        page = DuaScreen(dua: result.data as Dua);
        break;

      case SearchResultType.ziyarat:
        page = ZiyaratScreen(ziyarat: result.data as Ziyarat);
        break;

      case SearchResultType.quran:
        page = QuranReaderScreen(surah: result.data as QuranSurah);
        break;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  IconData _getIcon(SearchResultType type) {
    switch (type) {
      case SearchResultType.dua:
        return Icons.auto_stories_rounded;

      case SearchResultType.ziyarat:
        return Icons.mosque_rounded;

      case SearchResultType.quran:
        return Icons.menu_book_rounded;
    }
  }

  Widget _buildSearchModeSelector(
    BuildContext context,
    Color primary,
    ColorScheme colorScheme,
  ) {
    return RadioGroup<SearchMode>(
      groupValue: _mode,
      onChanged: (value) {
        if (value != null) {
          _changeSearchMode(value);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.15
                    : 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            RadioListTile<SearchMode>(
              value: SearchMode.titleOnly,
              activeColor: primary,
              title: const Text(
                'جستجو فقط در عنوان‌ها',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              secondary: Icon(Icons.title_rounded, color: primary),
            ),
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: colorScheme.outline.withValues(alpha: 0.15),
            ),
            RadioListTile<SearchMode>(
              value: SearchMode.titleAndContent,
              activeColor: primary,
              title: const Text(
                'جستجو در عنوان و محتوا',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              secondary: Icon(Icons.manage_search_rounded, color: primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {required bool noResults}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              noResults ? Icons.search_off_rounded : Icons.search_rounded,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 16),
            Text(
              noResults
                  ? 'نتیجه‌ای پیدا نشد'
                  : 'عبارت مورد نظر خود را وارد کنید',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 15,
                fontWeight: noResults ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (noResults) ...[
              const SizedBox(height: 8),
              Text(
                'عبارت دیگری را امتحان کنید',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, SearchResult result) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openResult(result),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_getIcon(result.type), color: primary, size: 27),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      result.title,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      result.subtitle,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_back_ios_rounded, size: 17, color: primary),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('جستجو'), centerTitle: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ==================================================
                // کادر جستجو
                // ==================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _controller,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: 'عبارت مورد نظر را جستجو کنید...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _controller.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'پاک کردن',
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: _clearSearch,
                            ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // دو حالت جستجو
                // ==================================================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _buildSearchModeSelector(
                    context,
                    primary,
                    colorScheme,
                  ),
                ),

                // ==================================================
                // نتایج
                // ==================================================
                Expanded(
                  child: _controller.text.trim().isEmpty
                      ? _buildEmptyState(context, noResults: false)
                      : _results.isEmpty
                      ? _buildEmptyState(context, noResults: true)
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                          itemCount: _results.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return _buildResultItem(context, _results[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
