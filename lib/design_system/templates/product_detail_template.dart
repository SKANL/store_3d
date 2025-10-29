import 'package:flutter/material.dart';
import '../atoms/model_preview.dart';

import '../../models/product_model.dart';
import '../atoms/price_tag.dart';
import '../molecules/cart_action_button.dart';

class ProductDetailTemplate extends StatelessWidget {
  final Product product;
  final int cartCount;
  final VoidCallback onAddToCart;
  final VoidCallback onCartTap;

  const ProductDetailTemplate({
    super.key,
    required this.product,
    required this.cartCount,
    required this.onAddToCart,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          CartActionButton(count: cartCount, onPressed: onCartTap),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ModelPreview(
                src: product.imageUrl,
                alt: product.title,
                ar: true, // Keep AR available
                autoRotate: false, // Disable auto-rotate for faster initial load
                cameraControls: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              PriceTag(price: product.price),
            ],
          ),
          const SizedBox(height: 16),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onAddToCart,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Añadir al carrito'),
          ),
        ],
      ),
    );
  }
}