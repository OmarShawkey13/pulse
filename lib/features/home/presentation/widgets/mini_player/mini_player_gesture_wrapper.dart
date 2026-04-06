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
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isExpanded = controller.value > 0.1;
        return GestureDetector(
          // Allow gestures to pass through to the list when the player is collapsed
          // and the touch is not on the mini player area.
          behavior: isExpanded
              ? HitTestBehavior.opaque
              : HitTestBehavior.deferToChild,
          onTap: () {
            if (!isExpanded) {
              controller.animateTo(1.0, curve: Curves.fastOutSlowIn);
            }
          },
          onVerticalDragUpdate: (details) {
            final double delta =
                details.primaryDelta! / (maxHeight - minHeight);
            controller.value -= delta;
          },
          onVerticalDragEnd: (details) {
            final double velocity = details.primaryVelocity ?? 0;
            if (velocity < -500) {
              controller.animateTo(1.0, curve: Curves.easeOutCubic);
            } else if (velocity > 500) {
              controller.animateTo(0.0, curve: Curves.easeOutCubic);
            } else if (controller.value > 0.5) {
              controller.animateTo(1.0, curve: Curves.easeOutCubic);
            } else {
              controller.animateTo(0.0, curve: Curves.easeOutCubic);
            }
          },
          child: child,
        );
      },
    );
  }
}
