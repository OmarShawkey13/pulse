import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

class SongFavoriteButton extends StatelessWidget {
  final bool isFav;
  final bool isDark;
  final VoidCallback onPressed;

  const SongFavoriteButton({
    super.key,
    required this.isFav,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: isFav
            ? ColorsManager.primary.withValues(alpha: 0.2)
            : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
      ),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(isFav),
          color: isFav
              ? ColorsManager.primary
              : (isDark ? Colors.white70 : Colors.black54),
          size: 28,
        ),
      ),
    );
  }
}
