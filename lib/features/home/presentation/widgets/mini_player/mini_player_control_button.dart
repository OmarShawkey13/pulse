import 'package:flutter/material.dart';

class MiniPlayerControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;

  const MiniPlayerControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(icon, size: size),
      onPressed: onPressed,
    );
  }
}
