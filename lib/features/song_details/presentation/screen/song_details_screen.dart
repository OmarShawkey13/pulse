import 'package:flutter/material.dart';
import 'package:pulse/core/utils/extensions/context_extension.dart';
import 'package:pulse/features/song_details/presentation/widgets/animated_wave_background.dart';
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
  final VoidCallback? onClose;

  const _SongDetailsAppBar({this.onClose});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
