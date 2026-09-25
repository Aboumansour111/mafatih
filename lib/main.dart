import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const MafatihApp());
}

class MafatihApp extends StatefulWidget {
  const MafatihApp({super.key});

  @override
  State<MafatihApp> createState() => _MafatihAppState();
}

class _MafatihAppState extends State<MafatihApp> {
  late final ThemeService _themeService;

  @override
  void initState() {
    super.initState();

    _themeService = ThemeService();

    _themeService.addListener(_onThemeChanged);

    _themeService.loadTheme();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    _themeService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      themeService: _themeService,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'مفاتیح یمانی',
        theme: _lightTheme(),
        darkTheme: _darkTheme(),
        themeMode: _themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff00695c),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xfffaf6ef),
      textTheme: GoogleFonts.vazirmatnTextTheme().apply(
        fontFamily: _themeService.fontFamily,
      ),
      fontFamily: _themeService.fontFamily,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Color(0xff00695c),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardColor: Colors.white,
      dividerColor: const Color(0xff00695c).withValues(alpha: 0.2),
    );
  }

  ThemeData _darkTheme() {
    // تیره‌تر برای مطالعه راحت‌تر در شب
    const Color background = Color(0xff0a1614);
    const Color surface = Color(0xff12211e);
    const Color surfaceVariant = Color(0xff1a2e29);
    const Color primary = Color(0xff26a69a);
    const Color primaryLight = Color(0xff4db6ac);
    const Color textPrimary = Color(0xfff1f7f4);
    const Color textSecondary = Color(0xffc5d8d2);
    const Color textMuted = Color(0xff8aa39c);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        onPrimary: Colors.white,
        secondary: primary,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        surfaceContainerHighest: surfaceVariant,
        error: Color(0xffff7676),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.vazirmatnTextTheme(ThemeData.dark().textTheme)
          .apply(
            bodyColor: textPrimary,
            displayColor: textPrimary,
            fontFamily: _themeService.fontFamily,
          ),
      fontFamily: _themeService.fontFamily,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Color(0xff0e1c19),
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardColor: surface,
      dividerColor: primary.withValues(alpha: 0.28),
      iconTheme: const IconThemeData(color: Color(0xffb8d5ce)),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryLight;
          }
          return const Color(0xff78918a);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary.withValues(alpha: 0.45);
          }
          return const Color(0xff1e322e);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary.withValues(alpha: 0.6);
          }
          return const Color(0xff557069);
        }),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: textMuted),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: surface,
        textColor: textPrimary,
        iconColor: primaryLight,
        subtitleTextStyle: TextStyle(color: textSecondary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: textSecondary, fontSize: 16),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xff1a302b),
        contentTextStyle: TextStyle(color: textPrimary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class ThemeScope extends InheritedWidget {
  final ThemeService themeService;

  const ThemeScope({
    super.key,
    required this.themeService,
    required super.child,
  });

  static ThemeService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope در بالای این Widget وجود ندارد.');
    return scope!.themeService;
  }

  @override
  bool updateShouldNotify(ThemeScope oldWidget) {
    return themeService != oldWidget.themeService;
  }
}
