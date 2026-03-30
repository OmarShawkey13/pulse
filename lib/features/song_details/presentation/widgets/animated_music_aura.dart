import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class AnimatedMusicAura extends StatefulWidget {
  const AnimatedMusicAura({super.key});

  @override
  State<AnimatedMusicAura> createState() => _AnimatedMusicAuraState();
}

class _AnimatedMusicAuraState extends State<AnimatedMusicAura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // حركة أبطأ وأكثر مهابة (20 ثانية للدورة الكاملة)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (prev, curr) => curr is HomeWaveColorUpdated,
      builder: (context, state) {
        final isDark = themeCubit.isDarkMode;
        final auraColor = homeCubit.waveColor ?? ColorsManager.primary;
        final surfaceColor =
            isDark ? ColorsManager.darkSurface : ColorsManager.lightSurface;

        return RepaintBoundary(
          child: Stack(
            children: [
              // 1. قاعدة الخلفية العميقة
              Container(color: surfaceColor),

              // 2. السديم المتحرك (Nebula Flow)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _AuraPainter(
                      animationValue: _controller.value,
                      color: auraColor,
                    ),
                  );
                },
              ),

              // 3. طبقة التظليل السينمائي (Vignette & Blur)
              // تعطي تركيزاً على المنتصف وتجعل الأطراف تتلاشى بنعومة
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.3), // التركيز خلف الـ Artwork
                    radius: 1.5,
                    colors: [
                      Colors.transparent,
                      surfaceColor.withValues(alpha: 0.2),
                      surfaceColor.withValues(alpha: 0.8),
                      surfaceColor,
                    ],
                    stops: const [0.0, 0.4, 0.8, 1.0],
                  ),
                ),
              ),

              // 4. طبقة نسيج خفيفة جداً (Subtle Grain Feel)
              Opacity(
                opacity: 0.02,
                child: Container(color: ColorsManager.lightSurface),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AuraPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _AuraPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.35);

    // استخدام BlendMode.plus يجعل الألوان "تضيء" عند تداخلها
    final paint = Paint()..blendMode = BlendMode.plus;

    // رسم 5 كتل لونية بمسارات وسرعات مختلفة لخلق عمق بصري
    _drawFluidBlob(canvas, size, center, paint, phase: 0.0, scale: 1.0, speedX: 1.0, speedY: 0.7);
    _drawFluidBlob(canvas, size, center, paint, phase: math.pi * 0.4, scale: 0.8, speedX: 0.6, speedY: 1.2);
    _drawFluidBlob(canvas, size, center, paint, phase: math.pi * 0.8, scale: 1.2, speedX: 1.3, speedY: 0.5);
    _drawFluidBlob(canvas, size, center, paint, phase: math.pi * 1.2, scale: 0.6, speedX: 0.4, speedY: 0.9);
    _drawFluidBlob(canvas, size, center, paint, phase: math.pi * 1.6, scale: 0.9, speedX: 0.8, speedY: 1.1);
  }

  void _drawFluidBlob(
      Canvas canvas,
      Size size,
      Offset center,
      Paint paint, {
        required double phase,
        required double scale,
        required double speedX,
        required double speedY,
      }) {
    final t = animationValue * 2 * math.pi;

    // مسار Lissajous للحركة العضوية (Organic Motion)
    final dx = math.sin(t * speedX + phase) * (size.width * 0.3);
    final dy = math.cos(t * speedY + phase * 0.5) * (size.height * 0.2);
    final blobCenter = center + Offset(dx, dy);

    // تأثير التنفس (Breathing Radius)
    final baseRadius = size.width * 0.6 * scale;
    final radius = baseRadius + math.sin(t * 0.5 + phase) * (baseRadius * 0.2);

    // شفافية متغيرة تعطي إحساساً بالنبض
    final opacity = 0.12 + (math.sin(t + phase) * 0.04);

    final gradient = RadialGradient(
      colors: [
        color.withValues(alpha: opacity),
        color.withValues(alpha: opacity * 0.4),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: blobCenter, radius: radius));

    paint.shader = gradient;

    // ضبابية ديناميكية (Dynamic Blur) تتغير مع الحركة
    paint.maskFilter = MaskFilter.blur(
      BlurStyle.normal,
      70 + (math.sin(t + phase).abs() * 30),
    );

    canvas.drawCircle(blobCenter, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _AuraPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color;
  }
}
