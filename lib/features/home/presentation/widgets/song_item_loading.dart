import 'package:flutter/material.dart';
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/features/home/presentation/widgets/song_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SongItemLoading extends StatelessWidget {
  const SongItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SongItem(
        song: SongModel(
          id: 0,
          path: '',
          title: 'Song Title Placeholder',
          artist: 'Artist Name Placeholder',
        ),
        isPlaying: false,
        loadArtwork: false, // تعطيل تحميل الصورة لمنع الـ crash أثناء التحميل
      ),
    );
  }
}
