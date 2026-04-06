import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class ControlSideButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  const ControlSideButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: isActive
            ? activeColor.withValues(alpha: 0.12)
            : Colors.transparent,
        foregroundColor: isActive
            ? activeColor
            : (isDark
                  ? ColorsManager.darkTextSecondary.withValues(alpha: 0.6)
                  : ColorsManager.lightTextSecondary.withValues(alpha: 0.6)),
        padding: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: Icon(icon, size: 26),
    );
  }
}
