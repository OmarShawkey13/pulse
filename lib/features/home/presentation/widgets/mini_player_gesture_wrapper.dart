import 'package:flutter/material.dart';

class MiniPlayerGestureWrapper extends StatelessWidget {
  final AnimationController controller;
  final double minHeight;
  final double maxHeight;
  final Widget child;

  const MiniPlayerGestureWrapper({
    super.key,
    required this.controller,
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.value > 0.5) {
          controller.animateTo(0, curve: Curves.easeOut);
        } else {
          controller.animateTo(1, curve: Curves.easeOut);
        }
      },
      onVerticalDragUpdate: (details) {
        controller.value -= details.primaryDelta! / (maxHeight - minHeight);
      },
      onVerticalDragEnd: (details) {
        final double velocity = details.primaryVelocity ?? 0;
        if (velocity < -500) {
          controller.animateTo(1, curve: Curves.easeOut);
        } else if (velocity > 500) {
          controller.animateTo(0, curve: Curves.easeOut);
        } else {
          if (controller.value > 0.5) {
            controller.animateTo(1, curve: Curves.easeOut);
          } else {
            controller.animateTo(0, curve: Curves.easeOut);
          }
        }
      },
      child: child,
    );
  }
}
