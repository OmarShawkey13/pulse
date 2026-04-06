import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';

class SongDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isPath;

  const SongDetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    this.isPath = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStylesManager.medium12.copyWith(
              color: isDark
                  ? ColorsManager.darkTextSecondary
                  : ColorsManager.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: isPath ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStylesManager.medium14.copyWith(
              color: isDark ? ColorsManager.white : ColorsManager.black,
            ),
          ),
        ],
      ),
    );
  }
}
