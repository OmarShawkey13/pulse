import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;
  final double gap;
  final Duration pauseDuration;

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(seconds: 20),
    this.gap = 50,
    this.pauseDuration = const Duration(seconds: 3),
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double _textWidth = 0;
  double _containerWidth = 0;

  bool get _shouldScroll => _textWidth > _containerWidth;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didUpdateWidget(covariant MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _measureTextWidth(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();

    return painter.width;
  }

  void _start() async {
    if (_controller.isAnimating) return;

    if (!_shouldScroll) {
      _controller.stop();
      return;
    }

    // ✅ FIX
    await Future<void>.delayed(widget.pauseDuration);

    if (!mounted) return;

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final newContainerWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        final newTextWidth = _measureTextWidth(context);

        if (newContainerWidth != _containerWidth ||
            newTextWidth != _textWidth) {
          _containerWidth = newContainerWidth;
          _textWidth = newTextWidth;

          if (_shouldScroll) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _start());
          } else {
            _controller.stop();
          }
        }

        if (!_shouldScroll) {
          return Text(widget.text, style: widget.style, maxLines: 1);
        }

        final totalWidth = _textWidth + widget.gap;

        return SizedBox(
          width: _containerWidth,
          height: widget.style.fontSize != null
              ? widget.style.fontSize! * 1.4
              : null,
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = _controller.value * totalWidth;

                return Stack(
                  children: [
                    Positioned(
                      left: -offset,
                      child: Text(widget.text, style: widget.style),
                    ),
                    Positioned(
                      left: -offset + totalWidth,
                      child: Text(widget.text, style: widget.style),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
