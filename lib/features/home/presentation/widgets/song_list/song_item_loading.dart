import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SongItemLoading extends StatelessWidget {
  const SongItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SongItem(
        song: MusicModel(
          id: 0,
          path: '',
          title: appTranslation().get('song_title_placeholder'),
          artist: appTranslation().get('artist'),
        ),
        isPlaying: false,
        loadArtwork: false, // تعطيل تحميل الصورة لمنع الـ crash أثناء التحميل
      ),
    );
  }
}
