import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MusicAuraPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final Animation<double> animation;
  final Color color;

  MusicAuraPainter({
    required this.shader,
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value * 25.0;

    shader.setFloat(0, t);
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);

    shader.setFloat(3, color.r);
    shader.setFloat(4, color.g);
    shader.setFloat(5, color.b);
    shader.setFloat(6, 1.0);

    final paint = Paint()
      ..shader = shader
      ..filterQuality = FilterQuality.low;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant MusicAuraPainter oldDelegate) {
    return false;
  }
}
