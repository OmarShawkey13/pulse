import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/constants/spacing.dart';

class HomeErrorWidget extends StatelessWidget {
  final String error;

  const HomeErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final home = HomeCubit.get(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: ColorsManager.error),
          verticalSpace12,
          Text(
            appTranslation().get('oops'),
            style: TextStylesManager.regular20,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              appTranslation().get(error),
              textAlign: TextAlign.center,
              style: TextStylesManager.regular14.copyWith(
                color: ColorsManager.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => home.loadSongs(retry: true),
            icon: const Icon(Icons.refresh),
            label: Text(appTranslation().get('try_again')),
          ),
        ],
      ),
    );
  }
}
