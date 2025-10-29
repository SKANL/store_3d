import 'package:flutter/material.dart';

class QuantityCounter extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantityCounter({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Cantidad',
      value: '$value',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
          color: cs.surfaceContainerHighest,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              style: IconButton.styleFrom(
                backgroundColor: cs.surfaceContainerLow,
                minimumSize: const Size(36, 36),
              ),
              onPressed: value > min ? () => onChanged(value - 1) : null,
              tooltip: 'Disminuir',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Text(
                  '$value',
                  key: ValueKey(value),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: cs.primaryContainer,
                foregroundColor: cs.onPrimaryContainer,
                minimumSize: const Size(36, 36),
              ),
              onPressed: value < max ? () => onChanged(value + 1) : null,
              tooltip: 'Aumentar',
            ),
          ],
        ),
      ),
    );
  }
}