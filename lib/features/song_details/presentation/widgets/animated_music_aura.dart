import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
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
    final program = await ui.FragmentProgram.fromAsset(
      'assets/shaders/aura.frag',
    );

    if (mounted) {
      setState(() {
        _shader = program.fragmentShader();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shader == null) return const SizedBox.shrink();

    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (prev, curr) => curr is HomeWaveColorUpdated,
      builder: (context, state) {
        final isDark = themeCubit.isDarkMode;
        final auraColor = homeCubit.waveColor ?? ColorsManager.primary;

        final surfaceColor = isDark
            ? ColorsManager.darkBackground
            : ColorsManager.lightBackground;

        return Stack(
          fit: StackFit.expand,
          children: [
            // الخلفية
            ColoredBox(color: surfaceColor),

            // 🔥 shader layer (خفيف جدًا)
            RepaintBoundary(
              child: CustomPaint(
                painter: MusicAuraPainter(
                  shader: _shader!,
                  animation: _controller,
                  color: auraColor,
                ),
              ),
            ),

            // 🔥 overlay خفيف بدل blur
            IgnorePointer(
              child: Container(
                color: surfaceColor.withValues(alpha: 0.08),
              ),
            ),

            // vignette أخف
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 1.3,
                    colors: [
                      Colors.transparent,
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
