import 'package:flutter/material.dart';

import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<_FontOption> _fonts = [
    _FontOption(
      name: 'وزیرمتن',
      family: 'Vazirmatn',
      description: 'مدرن و خوانا',
    ),
    _FontOption(name: 'شبنم', family: 'Shabnam', description: 'نرم و دوستانه'),
    _FontOption(name: 'ساحل', family: 'Sahel', description: 'ساده و متعادل'),
    _FontOption(name: 'صمیم', family: 'Samim', description: 'صمیمی و خوش‌خوان'),
    _FontOption(name: 'استعداد', family: 'Estedad', description: 'مدرن و رسمی'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final themeService = ThemeScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        children: [
          _buildHeader(context, colorScheme),

          const SizedBox(height: 24),

          Text(
            'فونت برنامه',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'فونت مورد علاقه خود را برای تمام بخش‌های برنامه انتخاب کنید.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              height: 1.8,
            ),
          ),

          const SizedBox(height: 16),

          ..._fonts.map(
            (font) => _FontCard(
              option: font,
              selected: themeService.fontFamily == font.family,
              onTap: () {
                themeService.setFont(font.family);
              },
            ),
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.55,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: colorScheme.primary,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'انتخاب فونت بلافاصله روی کل برنامه اعمال می‌شود و انتخاب شما برای دفعات بعد ذخیره خواهد شد.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      height: 1.9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            colorScheme.primary,
            Color.lerp(
                  colorScheme.primary,
                  colorScheme.surface,
                  Theme.of(context).brightness == Brightness.dark ? 0.35 : 0.15,
                ) ??
                colorScheme.primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: const Icon(
              Icons.text_fields_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'ظاهر نوشته‌ها',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'پنج فونت فارسی برای انتخاب شما',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FontOption {
  final String name;
  final String family;
  final String description;

  const _FontOption({
    required this.name,
    required this.family,
    required this.description,
  });
}

class _FontCard extends StatelessWidget {
  final _FontOption option;
  final bool selected;
  final VoidCallback onTap;

  const _FontCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(21),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(21),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              border: Border.all(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant.withValues(alpha: 0.35),
                width: selected ? 1.6 : 1,
              ),
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.055)
                  : colorScheme.surface,
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    selected ? Icons.check_rounded : Icons.text_fields_rounded,
                    color: selected
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'مَفاتیح یمانی',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: option.family,
                          color: colorScheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 1),

                      Text(
                        '${option.name} • ${option.description}',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: option.family,
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
