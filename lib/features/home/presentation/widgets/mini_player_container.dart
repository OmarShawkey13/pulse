import 'dart:ui';

import 'package:flutter/material.dart';

class MiniPlayerContainer extends StatelessWidget {
  final double value;
  final double minHeight;
  final double maxHeight;
  final Widget child;

  const MiniPlayerContainer({
    super.key,
    required this.value,
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final height = lerpDouble(minHeight, maxHeight, value)!;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color ?? Colors.grey[900],
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16 * (1 - value)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
