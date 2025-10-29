import 'package:flutter/material.dart';

/// Lightweight thumbnail used in product cards to avoid creating
/// multiple heavy WebView / ModelViewer instances in a scrolling list.
class ModelThumbnail extends StatelessWidget {
  final String label;

  const ModelThumbnail({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Icon(
              Icons.threed_rotation,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withAlpha((0.9 * 255).round()),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha((0.9 * 255).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '3D',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
