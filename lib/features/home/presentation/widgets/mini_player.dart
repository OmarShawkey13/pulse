import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player_container.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player_content.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player_gesture_wrapper.dart';
import 'package:pulse/features/song_details/presentation/screen/song_details_screen.dart';

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
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 450),
        )..addListener(() {
          widget.onExpansionChanged?.call(_controller.value);
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _maxHeight = mediaQuery.size.height;
    _minHeight =
        70 + (mediaQuery.padding.bottom > 0 ? mediaQuery.padding.bottom : 12);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // إحنا اللي هنقرر
      onPopInvokedWithResult: (didPop, result) async {
        // لو الـ MiniPlayer مفتوح
        if (_controller.value > 0.1) {
          _controller.animateTo(
            0,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOut,
          );
        } else {
          // لو مقفول → اقفل التطبيق
          SystemNavigator.pop();
        }
      },
      child: BlocBuilder<HomeCubit, HomeStates>(
        buildWhen: (_, state) =>
            state is HomePlayerPlayState ||
            state is HomePlayerPauseState ||
            state is HomePlayerNextState ||
            state is HomePlayerPreviousState ||
            state is HomePlayerStopState,
        builder: (context, state) {
          final cubit = homeCubit;
          final songPath = cubit.currentSongPath;

          if (songPath == null || cubit.songs.isEmpty) {
            if (_controller.value > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _controller.value = 0;
                widget.onExpansionChanged?.call(0);
              });
            }
            return const SizedBox.shrink();
          }

          final song = cubit.songs.firstWhere(
            (e) => e.path == songPath,
            orElse: () => cubit.songs.first,
          );

          return AnimatedBuilder(
            animation: _controller,
            builder: (_, _) {
              final value = _controller.value;
              return MiniPlayerGestureWrapper(
                controller: _controller,
                minHeight: _minHeight,
                maxHeight: _maxHeight,
                child: MiniPlayerContainer(
                  value: value,
                  minHeight: _minHeight,
                  maxHeight: _maxHeight,
                  child: Stack(
                    children: [
                      /// Full Player
                      if (_maxHeight > 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: _maxHeight,
                          child: Opacity(
                            opacity: value,
                            child: IgnorePointer(
                              ignoring: value < 0.5,
                              child: SongDetailsScreen(
                                onClose: () => _controller.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 450),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                ),
                              ),
                            ),
                          ),
                        ),

                      /// Mini Player
                      Opacity(
                        opacity: (1 - value * 3).clamp(0.0, 1.0),
                        child: IgnorePointer(
                          ignoring: value > 0,
                          child: MiniPlayerContent(
                            song: song,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
