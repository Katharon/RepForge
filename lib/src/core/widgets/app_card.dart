import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(RepForgeSpacing.lg),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: RepForgeColorTokens.surfaceCard,
        border: Border.all(color: RepForgeColorTokens.borderSubtle),
        borderRadius: BorderRadius.circular(RepForgeRadius.lg),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
