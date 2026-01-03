import 'package:flutter/material.dart';
import 'package:pulse/core/utils/extensions/context_extension.dart';
import 'package:pulse/features/song_details/presentation/widgets/animated_wave_background.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_content.dart';

class SongDetailsScreen extends StatelessWidget {
  const SongDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _SongDetailsAppBar(),
      body: Stack(
        children: [
          AnimatedWaveBackground(),
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
  const _SongDetailsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 35),
        onPressed: () => context.pop,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
