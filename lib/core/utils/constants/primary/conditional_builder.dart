import 'package:flutter/material.dart';

class ConditionalBuilder extends StatelessWidget {
  final bool loadingState;
  final bool? errorState;
  final WidgetBuilder successBuilder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? errorBuilder;

  const ConditionalBuilder({
    super.key,
    required this.loadingState,
    this.errorState,
    required this.successBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (loadingState) {
      return loadingBuilder?.call(context) ??
          const Center(
            child: CircularProgressIndicator(),
          );
    }

    if (errorState != null && errorState!) {
      return errorBuilder?.call(context) ?? const SizedBox.shrink();
    }

    return successBuilder(context);
  }
}
