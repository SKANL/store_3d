import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final double price;

  const PriceTag({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '\$${price.toStringAsFixed(2)}',
        style: TextStyle(
          color: cs.onPrimaryContainer,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

