import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../molecules/cart_action_button.dart';
import '../organisms/product_card.dart';

class CatalogTemplate extends StatelessWidget {
  final List<Product> products;
  final List<String> categories;
  final String? selectedCategory;
  final void Function(String?) onCategorySelected;
  final void Function(Product) onProductSelected;
  final int cartCount;

  const CatalogTemplate({
    super.key,
    required this.products,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onProductSelected,
    required this.cartCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [
          CartActionButton(
            count: cartCount,
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                ChoiceChip(
                  label: Text(
                    'Todos',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selectedCategory == null
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  selected: selectedCategory == null,
                  showCheckmark: false,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  onSelected: (_) => onCategorySelected(null),
                ),
                const SizedBox(width: 8),
                ...categories.map((c) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          c,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: selectedCategory == c
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        selected: selectedCategory == c,
                        showCheckmark: false,
                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                        onSelected: (_) => onCategorySelected(c),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: GridView.builder(
                key: ValueKey(selectedCategory ?? 'all'),
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final p = products[i];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.96, end: 1),
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                    builder: (context, scale, child) => Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                    child: ProductCard(
                      product: p,
                      onTap: () => onProductSelected(p),
                    ),
                  );
                },
              ),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.98, end: 1).animate(animation),
                    child: child,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}