import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/constants/primary/conditional_builder.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';
import 'package:pulse/features/home/presentation/widgets/home_error_widget.dart';
import 'package:pulse/features/home/presentation/widgets/song_item_loading.dart';
import 'package:pulse/features/home/presentation/widgets/songs_list.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeLoadSongsLoadingState ||
          current is HomeLoadSongsErrorState ||
          current is HomeLoadSongsSuccessState,
      builder: (context, state) {
        return ConditionalBuilder(
          loadingState: state is HomeLoadSongsLoadingState,
          loadingBuilder: (_) => ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: 10,
            itemBuilder: (_, _) => const SongItemLoading(),
          ),
          errorState: homeCubit.songs.isEmpty,
          successBuilder: (_) => const SongsList(),
          errorBuilder: (_) => const HomeErrorWidget(error: 'No songs found'),
        );
      },
    );
  }
}
