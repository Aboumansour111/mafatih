import 'package:flutter/material.dart';

class FontSizeControls extends StatelessWidget {
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool canDecrease;
  final bool canIncrease;
  final Color? iconColor;

  const FontSizeControls({
    super.key,
    required this.onDecrease,
    required this.onIncrease,
    this.canDecrease = true,
    this.canIncrease = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'کوچک کردن فونت',
          onPressed: canDecrease ? onDecrease : null,
          icon: Icon(Icons.text_decrease_rounded, size: 23, color: color),
        ),
        IconButton(
          tooltip: 'بزرگ کردن فونت',
          onPressed: canIncrease ? onIncrease : null,
          icon: Icon(Icons.text_increase_rounded, size: 23, color: color),
        ),
      ],
    );
  }
}
