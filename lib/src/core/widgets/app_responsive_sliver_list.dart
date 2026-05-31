import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AppResponsiveSliverList extends StatelessWidget {
  const AppResponsiveSliverList({
    required this.children,
    super.key,
    this.padding = const EdgeInsets.fromLTRB(
      RepForgeSpacing.lg,
      0,
      RepForgeSpacing.lg,
      RepForgeSpacing.xl,
    ),
    this.maxWidth = 720,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: padding,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
