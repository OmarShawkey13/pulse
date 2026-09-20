import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class ControlSideButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isCompact;
  final VoidCallback onTap;
  final Color activeColor;

  const ControlSideButton({
    super.key,
    required this.icon,
    required this.isActive,
    this.isCompact = false,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeCubit.get(context).isDarkMode;
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        minimumSize: Size.square(isCompact ? 40 : 52),
        maximumSize: Size.square(isCompact ? 40 : 52),
        backgroundColor: isActive
            ? activeColor.withValues(alpha: 0.12)
            : ColorsManager.transparent,
        foregroundColor: isActive
            ? activeColor
            : (isDark
                  ? ColorsManager.darkTextSecondary.withValues(alpha: 0.6)
                  : ColorsManager.lightTextSecondary.withValues(alpha: 0.6)),
        padding: EdgeInsets.all(isCompact ? 8 : 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: Icon(icon, size: 26),
    );
  }
}
