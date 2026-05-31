import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

class PlaceholderDestinationPage extends StatelessWidget {
  const PlaceholderDestinationPage({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(title)),
        AppResponsiveSliverList(
          padding: const EdgeInsets.all(RepForgeSpacing.xl),
          children: [
            AppCard(
              padding: const EdgeInsets.all(RepForgeSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.metricValue,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: RepForgeSpacing.md),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
