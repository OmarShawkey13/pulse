import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';

class SongArtwork extends StatelessWidget {
  const SongArtwork({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomePlayerPlayState ||
          state is HomePlayerNextState ||
          state is HomePlayerPreviousState,
      builder: (context, state) {
        final cubit = homeCubit;
        final currentPath = cubit.currentSongPath;
        final song = cubit.songs.firstWhere(
          (e) => e.path == currentPath,
          orElse: () => cubit.songs.first,
        );
        final primaryColor = Theme.of(context).primaryColor;
        return Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipOval(
            child: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              artworkHeight: 300,
              artworkWidth: 300,
              artworkFit: BoxFit.cover,
              quality: 100, // زيادة الجودة لأعلى قيمة
              artworkQuality: FilterQuality.high,
              artworkBorder: BorderRadius.circular(200),
              nullArtworkWidget: const Icon(
                Icons.music_note_rounded,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
