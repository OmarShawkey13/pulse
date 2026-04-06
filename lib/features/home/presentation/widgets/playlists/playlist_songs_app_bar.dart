import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';

class PlaylistSongsAppBar extends StatelessWidget {
  final int playlistId;
  final String playlistName;
  final List<MusicModel> songs;
  final bool isDark;

  const PlaylistSongsAppBar({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.songs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final lastSongId = songs.isNotEmpty ? songs.last.id : null;

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: isDark
          ? ColorsManager.darkBackground
          : ColorsManager.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        title: Text(
          playlistName,
          style: TextStylesManager.bold20.copyWith(
            color: isDark
                ? ColorsManager.darkTextPrimary
                : ColorsManager.lightTextPrimary,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (lastSongId != null)
              QueryArtworkWidget(
                id: lastSongId,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                format: ArtworkFormat.PNG,
                quality: 100,
                size: 1000,
                nullArtworkWidget: _buildPlaceholder(),
              )
            else
              _buildPlaceholder(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.0),
                    (isDark
                            ? ColorsManager.darkBackground
                            : ColorsManager.lightBackground)
                        .withValues(alpha: 0.8),
                    isDark
                        ? ColorsManager.darkBackground
                        : ColorsManager.lightBackground,
                  ],
                  stops: const [0.0, 0.4, 0.8, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${songs.length} Songs',
                        style: TextStylesManager.medium14.copyWith(
                          color: (isDark
                              ? ColorsManager.darkTextSecondary
                              : ColorsManager.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (songs.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () {
                        homeCubit.playSong(
                          songs[0].path,
                          queue: songs.map((e) => e.path).toList(),
                        );
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Play All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.primary,
            ColorsManager.primary.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.music_note_rounded,
        size: 100,
        color: Colors.white24,
      ),
    );
  }
}
