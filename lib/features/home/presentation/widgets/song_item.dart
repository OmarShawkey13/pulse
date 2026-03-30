import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' hide SongModel;
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';

class SongItem extends StatelessWidget {
  final SongModel song;
  final bool isPlaying;
  final bool loadArtwork;
  final List<String>? queue;

  const SongItem({
    super.key,
    required this.song,
    required this.isPlaying,
    this.loadArtwork = true,
    this.queue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = themeCubit.isDarkMode;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: isPlaying
                  ? LinearGradient(
                      colors: [
                        ColorsManager.primary.withValues(alpha: 0.15),
                        ColorsManager.secondary.withValues(alpha: 0.05),
                        isDark
                            ? ColorsManager.darkSurface
                            : ColorsManager.lightSurface,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isPlaying
                  ? null
                  : (isDark
                            ? ColorsManager.darkCard
                            : ColorsManager.lightDivider)
                        .withValues(alpha: 0.2),
              boxShadow: isPlaying
                  ? [
                      BoxShadow(
                        color: ColorsManager.primary.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: () => homeCubit.playSong(song.path, queue: queue),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Aura Artwork
                      _AuraArtwork(
                        songId: song.id,
                        isPlaying: isPlaying,
                        loadArtwork: loadArtwork,
                      ),
                      horizontalSpace16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStylesManager.medium16.copyWith(
                                fontWeight: isPlaying
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isPlaying
                                    ? ColorsManager.primary
                                    : (isDark
                                          ? ColorsManager.darkTextPrimary
                                          : ColorsManager.lightTextPrimary),
                                letterSpacing: -0.2,
                              ),
                            ),
                            verticalSpace4,
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStylesManager.regular12.copyWith(
                                color: isPlaying
                                    ? (isDark
                                              ? ColorsManager.darkTextPrimary
                                              : ColorsManager.lightTextPrimary)
                                          .withValues(
                                            alpha: 0.7,
                                          )
                                    : (isDark
                                          ? ColorsManager.darkTextSecondary
                                          : ColorsManager.lightTextSecondary),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Trailing Action (Glassy button style)
                      if (isPlaying)
                        _PlayingAuraIcon()
                      else
                        Icon(
                          Icons.play_circle_outline_rounded,
                          color:
                              (isDark
                                      ? ColorsManager.darkTextSecondary
                                      : ColorsManager.lightTextSecondary)
                                  .withValues(
                                    alpha: 0.5,
                                  ),
                          size: 28,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuraArtwork extends StatelessWidget {
  final int songId;
  final bool isPlaying;
  final bool loadArtwork;

  const _AuraArtwork({
    required this.songId,
    required this.isPlaying,
    required this.loadArtwork,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isPlaying)
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.primary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        Hero(
          tag: 'song_artwork_$songId',
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: isPlaying
                  ? Border.all(
                      color: ColorsManager.primary.withValues(alpha: 0.5),
                      width: 2,
                    )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: loadArtwork
                  ? QueryArtworkWidget(
                      id: songId,
                      type: ArtworkType.AUDIO,
                      artworkHeight: 56,
                      artworkWidth: 56,
                      artworkFit: BoxFit.cover,
                      artworkBorder: const BorderRadius.all(.circular(18)),
                      nullArtworkWidget: _DefaultArtwork(isPlaying: isPlaying),
                    )
                  : _DefaultArtwork(isPlaying: isPlaying),
            ),
          ),
        ),
      ],
    );
  }
}

class _DefaultArtwork extends StatelessWidget {
  final bool isPlaying;

  const _DefaultArtwork({required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return Container(
      color: isPlaying
          ? ColorsManager.primary.withValues(alpha: 0.2)
          : (isDark ? ColorsManager.darkCard : ColorsManager.lightDivider),
      child: Icon(
        Icons.music_note_rounded,
        color: isPlaying
            ? ColorsManager.primary
            : (isDark
                  ? ColorsManager.darkTextSecondary
                  : ColorsManager.lightTextSecondary),
      ),
    );
  }
}

class _PlayingAuraIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: ColorsManager.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.pause_rounded,
        color: ColorsManager.lightSurface,
        size: 20,
      ),
    );
  }
}
