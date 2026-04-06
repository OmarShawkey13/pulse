import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player_container.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player_gesture_wrapper.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/player_stack.dart';

class MiniPlayer extends StatefulWidget {
  final ValueChanged<double>? onExpansionChanged;

  const MiniPlayer({super.key, this.onExpansionChanged});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double _minHeight = 80;
  double _maxHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(_handleAnimationUpdate);
  }

  void _handleAnimationUpdate() {
    widget.onExpansionChanged?.call(_controller.value);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _maxHeight = mediaQuery.size.height;
    _minHeight = 72 + mediaQuery.padding.bottom;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleAnimationUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _collapse() => _controller.animateTo(
    0,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (_controller.value > 0.1) {
          _collapse();
        } else {
          SystemNavigator.pop();
        }
      },
      child: BlocBuilder<HomeCubit, HomeStates>(
        buildWhen: (prev, curr) => _shouldRebuild(curr),
        builder: (context, state) {
          final cubit = homeCubit;
          final songPath = cubit.currentSongPath;

          if (songPath == null || cubit.songs.isEmpty) {
            _resetAnimation();
            return const SizedBox.shrink();
          }

          final song = cubit.songs.firstWhere(
            (e) => e.path == songPath,
            orElse: () => cubit.songs.first,
          );

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final value = _controller.value;
              final currentHeight =
                  lerpDouble(_minHeight, _maxHeight, value) ?? _minHeight;

              return SizedBox(
                height: currentHeight,
                child: MiniPlayerGestureWrapper(
                  controller: _controller,
                  minHeight: _minHeight,
                  maxHeight: _maxHeight,
                  child: MiniPlayerContainer(
                    value: value,
                    minHeight: _minHeight,
                    maxHeight: _maxHeight,
                    child: PlayerStack(
                      value: value,
                      minHeight: _minHeight,
                      song: song,
                      onClose: _collapse,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _shouldRebuild(HomeStates state) {
    return state is HomePlayerPlayState ||
        state is HomePlayerPauseState ||
        state is HomePlayerNextState ||
        state is HomePlayerPreviousState ||
        state is HomePlayerStopState ||
        state is HomeInitialState;
  }

  void _resetAnimation() {
    if (_controller.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.value = 0;
          widget.onExpansionChanged?.call(0);
        }
      });
    }
  }
}
