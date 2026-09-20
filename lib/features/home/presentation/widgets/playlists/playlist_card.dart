import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:pulse/core/errors/either.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/constants/routes.dart';
import 'package:pulse/core/utils/extensions/context_extension.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlist_card_placeholder.dart';

class PlaylistCard extends StatelessWidget {
  final Map<String, dynamic> playlist;
  final bool isDark;

  const PlaylistCard({super.key, required this.playlist, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          Routes.playlistSongs,
          arguments: PlaylistSongsRouteArgs(
            playlistId: playlist['id'] as int,
            playlistName: playlist['name'] as String,
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: (isDark ? ColorsManager.darkCard : ColorsManager.lightSurface)
              .withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: (isDark ? ColorsManager.white : ColorsManager.black)
                .withValues(
                  alpha: 0.05,
                ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<Either<Failure, List<MusicModel>>>(
                future: HomeCubit.get(context).getPlaylistSongs(playlist['id']),
                builder: (context, snapshot) {
                  final songs =
                      snapshot.data?.fold(
                        (_) => const <MusicModel>[],
                        (value) => value,
                      ) ??
                      const <MusicModel>[];
                  final hasSongs = songs.isNotEmpty;
                  final lastSongId = hasSongs ? songs.last.id : null;

                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: !hasSongs
                          ? LinearGradient(
                              colors: [
                                ColorsManager.primary,
                                ColorsManager.primary.withValues(alpha: 0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (hasSongs
                                      ? ColorsManager.black
                                      : ColorsManager.primary)
                                  .withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: hasSongs
                          ? QueryArtworkWidget(
                              id: lastSongId!,
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.cover,
                              artworkBorder: BorderRadius.circular(24),
                              quality: 100,
                              size: 1000,
                              format: ArtworkFormat.PNG,
                              nullArtworkWidget:
                                  const PlaylistCardPlaceholder(),
                            )
                          : const PlaylistCardPlaceholder(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStylesManager.bold14.copyWith(
                            color: isDark
                                ? ColorsManager.darkTextPrimary
                                : ColorsManager.lightTextPrimary,
                          ),
                        ),
                        verticalSpace2,
                        FutureBuilder<Either<Failure, List<MusicModel>>>(
                          future: HomeCubit.get(context).getPlaylistSongs(
                            playlist['id'],
                          ),
                          builder: (context, snapshot) {
                            final songs =
                                snapshot.data?.fold(
                                  (_) => const <MusicModel>[],
                                  (value) => value,
                                ) ??
                                const <MusicModel>[];
                            final count = songs.length;
                            return Text(
                              appTranslation().get(
                                'song_count',
                                params: {'count': count},
                              ),
                              style: TextStylesManager.regular10.copyWith(
                                color:
                                    (isDark
                                            ? ColorsManager.darkTextSecondary
                                            : ColorsManager.lightTextSecondary)
                                        .withValues(alpha: 0.7),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: ColorsManager.transparent,
                    child: InkWell(
                      onTap: () => _showDeleteConfirm(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.more_vert_rounded,
                          size: 18,
                          color: isDark
                              ? ColorsManager.darkTextSecondary
                              : ColorsManager.lightTextSecondary,
                        ),
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

  void _showDeleteConfirm(BuildContext context) {
    showModalBottomSheet<Object>(
      context: context,
      backgroundColor: isDark
          ? ColorsManager.darkCard
          : ColorsManager.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpace10,
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: (isDark ? ColorsManager.white : ColorsManager.black)
                  .withValues(
                    alpha: 0.1,
                  ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outline_rounded,
              color: ColorsManager.error,
            ),
            title: Text(
              appTranslation().get('delete_playlist'),
              style: TextStylesManager.medium16.copyWith(
                color: ColorsManager.error,
              ),
            ),
            onTap: () {
              HomeCubit.get(context).deletePlaylist(playlist['id']);
              context.pop;
            },
          ),
          verticalSpace20,
        ],
      ),
    );
  }
}
