import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_option_tile.dart';

class SongPlaylistSelectorSheet extends StatelessWidget {
  final MusicModel song;

  const SongPlaylistSelectorSheet({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final playlists = homeCubit.playlists;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white24 : Colors.black12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              verticalSpace24,
              Text(
                'Select Playlist',
                style: TextStylesManager.bold20.copyWith(
                  color: isDark ? ColorsManager.white : ColorsManager.black,
                ),
              ),
              verticalSpace16,
              if (playlists.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'No playlists created yet',
                    style: TextStylesManager.regular14.copyWith(
                      color: isDark
                          ? ColorsManager.darkTextSecondary
                          : ColorsManager.lightTextSecondary,
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return SongOptionTile(
                        icon: Icons.playlist_play_rounded,
                        label: playlist['name'],
                        onTap: () {
                          homeCubit.addSongToPlaylist(
                            playlistId: playlist['id'],
                            song: song,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to ${playlist['name']}'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
