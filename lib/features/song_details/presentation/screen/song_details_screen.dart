import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/extensions/context_extension.dart';
import 'package:pulse/features/song_details/presentation/widgets/animated_music_aura.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_content.dart';

class SongDetailsScreen extends StatelessWidget {
  final VoidCallback? onClose;

  const SongDetailsScreen({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _SongDetailsAppBar(onClose: onClose),
      body: const Stack(
        children: [
          AnimatedMusicAura(),
          SafeArea(
            child: SongDetailsContent(),
          ),
        ],
      ),
    );
  }
}

class _SongDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onClose;

  const _SongDetailsAppBar({this.onClose});

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'NOW PLAYING',
        style: TextStylesManager.bold14.copyWith(
          letterSpacing: 2,
          color: isDark
              ? ColorsManager.darkTextSecondary
              : ColorsManager.lightTextSecondary,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 35),
        onPressed: () {
          if (onClose != null) {
            onClose!();
          } else {
            context.pop;
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
