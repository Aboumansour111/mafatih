import 'package:flutter/material.dart';

import '../main.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeScope.of(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      tooltip: isDark ? 'حالت روشن' : 'حالت تاریک',

      onPressed: () async {
        await themeService.toggleTheme();
      },

      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),

        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.75, end: 1.0).animate(animation),

            child: FadeTransition(opacity: animation, child: child),
          );
        },

        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,

          key: ValueKey(isDark),

          size: 25,
        ),
      ),
    );
  }
}
