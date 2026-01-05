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
        if (controller.value <= 0.5) {
          controller.animateTo(
            1,
            duration: const Duration(milliseconds: 450),
            curve: Curves.fastLinearToSlowEaseIn,
          );
        }
      },
      onVerticalDragUpdate: (details) {
        controller.value -= details.primaryDelta! / (maxHeight - minHeight);
      },
      onVerticalDragEnd: (details) {
        final double velocity = details.primaryVelocity ?? 0;

        if (velocity < -700) {
          controller.animateTo(
            1,
            duration: const Duration(milliseconds: 450),
            curve: Curves.fastLinearToSlowEaseIn,
          );
        } else if (velocity > 700) {
          controller.animateTo(
            0,
            duration: const Duration(milliseconds: 450),
            curve: Curves.fastLinearToSlowEaseIn,
          );
        } else {
          if (controller.value > 0.4) {
            controller.animateTo(
              1,
              duration: const Duration(milliseconds: 450),
              curve: Curves.fastLinearToSlowEaseIn,
            );
          } else {
            controller.animateTo(
              0,
              duration: const Duration(milliseconds: 450),
              curve: Curves.fastLinearToSlowEaseIn,
            );
          }
        }
      },
      child: child,
    );
  }
}
