import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/theme_toggle_button.dart';

class DhikrCounterScreen extends StatefulWidget {
  const DhikrCounterScreen({super.key});

  @override
  State<DhikrCounterScreen> createState() => _DhikrCounterScreenState();
}

class _DhikrCounterScreenState extends State<DhikrCounterScreen>
    with SingleTickerProviderStateMixin {
  static const _prefsCountKey = 'dhikr_count';
  static const _prefsDhikrKey = 'dhikr_text';
  static const _prefsTargetKey = 'dhikr_target';

  static const List<String> _presets = [
    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَآلِ مُحَمَّدٍ الْأَئِمَّةِ وَالْمَهْدِيِّينَ وَسَلِّمْ تَسْلِيمًا',
    'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَآلِ مُحَمَّدٍ',
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'اللَّهُ أَكْبَرُ',
    'أَسْتَغْفِرُ اللَّهَ',
    'لَا إِلٰهَ إِلَّا اللَّهُ',
    'يَا عَلِيُّ',
    'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
  ];

  static const List<int> _targets = [100, 40, 313, 1000];

  int _count = 0;
  int _target = 100;
  String _dhikr = _presets.first;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _load();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt(_prefsCountKey) ?? 0;
      _target = prefs.getInt(_prefsTargetKey) ?? 100;
      _dhikr = prefs.getString(_prefsDhikrKey) ?? _presets.first;
    });
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsCountKey, _count);
    await prefs.setInt(_prefsTargetKey, _target);
    await prefs.setString(_prefsDhikrKey, _dhikr);
  }

  Future<void> _tap() async {
    HapticFeedback.lightImpact();
    setState(() => _count += 1);
    await _persist();
    await _pulse.reverse();
    await _pulse.forward();
    if (_target > 0 && _count > 0 && _count % _target == 0) {
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _reset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('بازنشانی شمارنده', textDirection: TextDirection.rtl),
        content: const Text(
          'شمارش فعلی پاک شود؟',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('خیر'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('بله'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _count = 0);
      await _persist();
    }
  }

  double get _progress {
    if (_target <= 0) return 0;
    return (_count % _target) / _target;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = cs.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ذکرشمار'),
        centerTitle: true,
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            children: [
              // انتخاب ذکر
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'انتخاب ذکر',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemCount: _presets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = _presets[index];
                    final selected = item == _dhikr;
                    return ChoiceChip(
                      label: Text(
                        item.length > 28 ? '${item.substring(0, 26)}…' : item,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w600,
                          color: selected ? primary : cs.onSurface,
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) async {
                        setState(() => _dhikr = item);
                        await _persist();
                      },
                      selectedColor: primary.withValues(alpha: 0.16),
                      backgroundColor: cs.surfaceContainerHighest.withValues(
                        alpha: isDark ? 0.4 : 0.7,
                      ),
                      side: BorderSide(
                        color: selected
                            ? primary.withValues(alpha: 0.45)
                            : cs.outline.withValues(alpha: 0.15),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),

              // کارت ذکر فعلی
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      primary.withValues(alpha: isDark ? 0.22 : 0.12),
                      cs.tertiary.withValues(alpha: isDark ? 0.14 : 0.08),
                    ],
                  ),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  _dhikr,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.9,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // کانتر دایره‌ای
              ScaleTransition(
                scale: _pulse,
                child: GestureDetector(
                  onTap: _tap,
                  child: SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: CircularProgressIndicator(
                            value: _progress == 0 && _count == 0 ? 0 : (_progress == 0 ? 1 : _progress),
                            strokeWidth: 10,
                            backgroundColor: cs.outlineVariant.withValues(
                              alpha: 0.25,
                            ),
                            color: primary,
                          ),
                        ),
                        Container(
                          width: 196,
                          height: 196,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
                                      0.45,
                                    ) ??
                                    primary,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.35),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'هدف: $_target',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'برای شمارش لمس کن',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
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
              const SizedBox(height: 28),

              // اهداف
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'هدف شمارش',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _targets.map((t) {
                  final selected = t == _target;
                  return ChoiceChip(
                    label: Text(
                      '$t',
                      style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w600,
                        color: selected ? primary : cs.onSurface,
                      ),
                    ),
                    selected: selected,
                    onSelected: (_) async {
                      setState(() => _target = t);
                      await _persist();
                    },
                    selectedColor: primary.withValues(alpha: 0.16),
                    backgroundColor: cs.surfaceContainerHighest.withValues(
                      alpha: isDark ? 0.4 : 0.7,
                    ),
                    side: BorderSide(
                      color: selected
                          ? primary.withValues(alpha: 0.45)
                          : cs.outline.withValues(alpha: 0.15),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // دکمه‌ها
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _count == 0 ? null : _reset,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('بازنشانی'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _tap,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('شمارش'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
