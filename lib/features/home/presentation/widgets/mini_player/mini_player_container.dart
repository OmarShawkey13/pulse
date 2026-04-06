import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

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
    final borderRadius = lerpDouble(20.0, 0.0, value) ?? 0.0;
    return Container(
      width: double.infinity,
      height: maxHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorsManager.darkCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
        boxShadow: value < 0.1
            ? [
                BoxShadow(
                  color: ColorsManager.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: OverflowBox(
        minHeight: maxHeight,
        maxHeight: maxHeight,
        alignment: Alignment.topCenter,
        child: child,
      ),
    );
  }
}
