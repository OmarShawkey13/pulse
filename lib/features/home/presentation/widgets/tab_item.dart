import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';

class TabItem extends StatelessWidget {
  final String title;
  final int index;
  final AnimationController controller;
  final Color unselectedColor;
  final VoidCallback onTap;

  const TabItem({
    super.key,
    required this.title,
    required this.index,
    required this.controller,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final isHighlighted = controller.value.round() == index;
              return AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStylesManager.medium14.copyWith(
                  color: isHighlighted ? ColorsManager.white : unselectedColor,
                ),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
