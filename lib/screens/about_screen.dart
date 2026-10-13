import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _urlMafatihYamani = 'https://t.me/MAFATIH10313';
  static const _urlAmalArabi = 'https://t.me/MahdiMedia5';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // fallback
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          tooltip: 'بازگشت',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('درباره ما', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          children: [
            // هدر
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 26),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    primary,
                    Color.lerp(
                          primary,
                          isDark
                              ? const Color(0xff061814)
                              : const Color(0xff003f38),
                          0.5,
                        ) ??
                        primary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.28),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'همراهی برای لحظه‌های دعا و نیایش',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // معرفی — با لینک‌های قابل‌کلیک روی نام کانال‌ها
            _SectionCard(
              isDark: isDark,
              colorScheme: colorScheme,
              icon: Icons.favorite_rounded,
              title: 'معرفی',
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    height: 2.0,
                    color: colorScheme.onSurface,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'این اپلیکیشن توسط جمعی از مومنین به سید احمد الحسن توسعه داده شده و منابع اصلی برنامه کانال‌های ',
                    ),
                    TextSpan(
                      text: '«مفاتیح یمانی»',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                        decorationColor: primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _openUrl(_urlMafatihYamani),
                    ),
                    const TextSpan(text: ' و '),
                    TextSpan(
                      text: '«الأعمال العبادية لمجموعة الدعوة المهدوية»',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                        decorationColor: primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _openUrl(_urlAmalArabi),
                    ),
                    const TextSpan(
                      text:
                          ' و کتاب «مفاتیح الجنان» شیخ عباس قمی می‌باشد.',
                    ),
                  ],
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 14),

            // منابع — کارت‌های قابل‌کلیک
            _SectionCard(
              isDark: isDark,
              colorScheme: colorScheme,
              icon: Icons.library_books_rounded,
              title: 'منابع اصلی',
              child: Column(
                children: [
                  _SourceItem(
                    title: 'کانال مفاتیح یمانی',
                    subtitle: 'منبع اصلی ادعیه و اعمال — برای ورود لمس کنید',
                    icon: Icons.telegram,
                    url: _urlMafatihYamani,
                  ),
                  const SizedBox(height: 10),
                  _SourceItem(
                    title: 'الأعمال العبادية لمجموعة الدعوة المهدوية',
                    subtitle: 'کانال عربی اعمال عبادی — برای ورود لمس کنید',
                    icon: Icons.telegram,
                    url: _urlAmalArabi,
                  ),
                  const SizedBox(height: 10),
                  const _SourceItem(
                    title: 'مفاتیح الجنان',
                    subtitle: 'اثر شیخ عباس قمی',
                    icon: Icons.menu_book_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final ColorScheme colorScheme;
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.isDark,
    required this.colorScheme,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.12)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SourceItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? url;

  const _SourceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.url,
  });

  Future<void> _open() async {
    if (url == null) return;
    final uri = Uri.parse(url!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasLink = url != null && url!.isNotEmpty;

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: hasLink
            ? Border.all(color: colorScheme.primary.withValues(alpha: 0.22))
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: hasLink ? colorScheme.primary : colorScheme.onSurface,
                    decoration:
                        hasLink ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (hasLink) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.open_in_new_rounded,
              size: 16,
              color: colorScheme.primary.withValues(alpha: 0.8),
            ),
          ],
        ],
      ),
    );

    if (!hasLink) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _open,
        child: content,
      ),
    );
  }
}
