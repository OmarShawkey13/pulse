import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';

class HomeErrorWidget extends StatelessWidget {
  final String error;

  const HomeErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: ColorsManager.error),
          verticalSpace12,
          Text(
            'Oops!',
            style: TextStylesManager.regular20,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => homeCubit.loadSongs(retry: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
