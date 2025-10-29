import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../atoms/price_tag.dart';
import '../molecules/quantity_counter.dart';

class CartItemRow extends StatelessWidget {
  final Product product;
  final void Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemRow({
    super.key,
    required this.product,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      QuantityCounter(
                        value: product.quantity,
                        onChanged: onQuantityChanged,
                        min: 1,
                        max: 99,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                            child: Column(
                              key: ValueKey('${product.id}-${product.quantity}'),
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: PriceTag(price: product.price * product.quantity),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${product.quantity} x ${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: cs.error,
              onPressed: onRemove,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}