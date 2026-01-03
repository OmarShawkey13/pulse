import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedWaveBackground extends StatefulWidget {
  const AnimatedWaveBackground({super.key});

  @override
  State<AnimatedWaveBackground> createState() => _AnimatedWaveBackgroundState();
}

class _AnimatedWaveBackgroundState extends State<AnimatedWaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Stack(
      children: [
        // Base background
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),

        // Animated waves
        AnimatedBuilder(
          animation: _controller,
          builder: (_, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _WavePainter(
                animationValue: _controller.value,
                color: primaryColor,
              ),
            );
          },
        ),

        // Gradient overlay (for readability)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withValues(alpha: 0.15),
                Theme.of(
                  context,
                ).scaffoldBackgroundColor.withValues(alpha: 0.7),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  const _WavePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Wave 1
    paint.color = color.withValues(alpha: 0.20);
    _drawWave(canvas, size, paint, frequency: 1.0, phase: 0);

    // Wave 2
    paint.color = color.withValues(alpha: 0.30);
    _drawWave(canvas, size, paint, frequency: 0.8, phase: 2);

    // Wave 3
    paint.color = color.withValues(alpha: 0.15);
    _drawWave(canvas, size, paint, frequency: 1.2, phase: 4);
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    Paint paint, {
    required double frequency,
    required double phase,
  }) {
    final path = Path();
    final centerY = size.height * 0.5;
    const amplitude = 30.0;
    final waveLength = size.width / 1.5;

    final move = animationValue * 2 * math.pi;

    path.moveTo(0, size.height);
    path.lineTo(0, centerY);

    for (double x = 0; x <= size.width; x++) {
      final y =
          centerY +
          amplitude *
              math.sin(
                (x / waveLength * 2 * math.pi * frequency) + move + phase,
              );
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
