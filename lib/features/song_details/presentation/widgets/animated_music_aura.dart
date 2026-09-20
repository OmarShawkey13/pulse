import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';
import 'package:pulse/features/song_details/presentation/widgets/music_aura_painter.dart';

class MusicAura extends StatefulWidget {
  const MusicAura({super.key});

  @override
  State<MusicAura> createState() => _MusicAuraState();
}

class _MusicAuraState extends State<MusicAura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(
        'assets/shaders/aura.frag',
      );

      if (mounted) {
        setState(() {
          _shader = program.fragmentShader();
        });
      }
    } catch (_) {
      // Keep the gradient fallback below when a device cannot compile the
      // runtime effect instead of leaving the player with a blank background.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (_, state) =>
          state is ThemeChangeThemeState || state is ThemeLanguageUpdatedState,
      builder: (context, _) {
        final isDark = ThemeCubit.get(context).isDarkMode;
        final surfaceColor = isDark
            ? ColorsManager.darkBackground
            : ColorsManager.lightBackground;

        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (_, state) => state is HomeWaveColorUpdated,
          builder: (context, _) {
            final auraColor =
                HomeCubit.get(context).waveColor ?? ColorsManager.primary;

            return Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: surfaceColor),
                if (_shader != null)
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: MusicAuraPainter(
                        shader: _shader!,
                        animation: _controller,
                        color: auraColor,
                      ),
                    ),
                  )
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.2),
                        radius: 1.1,
                        colors: [
                          auraColor.withValues(alpha: 0.28),
                          surfaceColor,
                        ],
                      ),
                    ),
                  ),
                IgnorePointer(
                  child: ColoredBox(
                    color: surfaceColor.withValues(alpha: 0.08),
                  ),
                ),
                IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.2),
                        radius: 1.3,
                        colors: [
                          ColorsManager.transparent,
                          surfaceColor.withValues(alpha: 0.4),
                          surfaceColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
