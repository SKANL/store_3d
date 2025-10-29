import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
// price_tag not used after redesign; kept for future if needed
import '../atoms/model_thumbnail.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + price overlay
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Hero(
                    tag: 'product-image-${product.id}',
                    child: ModelThumbnail(label: product.title),
                  ),
                ),
                // Price badge (prominent)
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Floating add button
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: FloatingActionButton.small(
                    heroTag: 'add-${product.id}',
                    onPressed: () {
                      context.read<CartProvider>().addProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Agregado: ${product.title}'),
                          action: SnackBarAction(
                            label: 'Deshacer',
                            onPressed: () => context.read<CartProvider>().removeProduct(product.id),
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.add_shopping_cart),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        product.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}