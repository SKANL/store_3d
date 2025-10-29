import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../organisms/cart_item_row.dart';
import '../theme.dart';

class CartTemplate extends StatelessWidget {
  const CartTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: items.isEmpty ? null : cart.clearCart,
            tooltip: 'Vaciar carrito',
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: items.isEmpty
            ? Center(
                child: Text(
                  'Tu carrito está vacío',
                  style: theme.textTheme.titleMedium,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(
                        Icons.delete,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    secondaryBackground: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(
                        Icons.delete,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    onDismissed: (_) {
                      context.read<CartProvider>().removeProduct(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Producto eliminado del carrito')),
                      );
                    },
                    child: CartItemRow(
                      product: item,
                      onQuantityChanged: (qty) => context
                          .read<CartProvider>()
                          .updateQuantity(item.id, qty),
                      onRemove: () => context.read<CartProvider>().removeProduct(item.id),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [BoxShadow(blurRadius: 8, color: AppColors.shadow)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total'),
                    Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: items.isEmpty
                    ? null
                    : () => Navigator.pushNamed(context, '/checkout'),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Proceder a pagar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}