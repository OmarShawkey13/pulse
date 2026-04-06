import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player.dart';

class HomeMiniPlayerWrapper extends StatelessWidget {
  final void Function(double) onExpansionChanged;

  const HomeMiniPlayerWrapper({
    super.key,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeStates, bool>(
      selector: (state) => homeCubit.currentSongPath != null,
      builder: (context, hasSong) {
        if (!hasSong) return const SizedBox.shrink();

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: 1.0,
          child: MiniPlayer(onExpansionChanged: onExpansionChanged),
        );
      },
    );
  }
}
