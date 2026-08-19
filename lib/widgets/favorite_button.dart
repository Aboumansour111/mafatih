import 'package:flutter/material.dart';

import '../services/favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  final String id;
  final double size;

  const FavoriteButton({super.key, required this.id, this.size = 27});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoriteService _favoriteService = FavoriteService();

  bool _isFavorite = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final result = await _favoriteService.isFavorite(widget.id);

    if (!mounted) return;

    setState(() {
      _isFavorite = result;
      _loading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    final result = await _favoriteService.toggleFavorite(widget.id);

    if (!mounted) return;

    setState(() {
      _isFavorite = result;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          result ? 'به علاقه‌مندی‌ها اضافه شد' : 'از علاقه‌مندی‌ها حذف شد',
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(width: widget.size + 20, height: widget.size + 20);
    }

    return IconButton(
      tooltip: _isFavorite ? 'حذف از علاقه‌مندی‌ها' : 'افزودن به علاقه‌مندی‌ها',
      onPressed: _toggleFavorite,
      icon: Icon(
        _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: _isFavorite ? Colors.red : Colors.grey,
        size: widget.size,
      ),
    );
  }
}
