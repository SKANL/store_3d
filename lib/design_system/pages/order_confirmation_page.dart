import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final name = args?['name'] as String? ?? '';
    final address = args?['address'] as String? ?? '';

    final cart = context.read<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pedido confirmado')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 84, color: Colors.green),
            const SizedBox(height: 16),
            Text('Gracias por tu compra, $name', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tu pedido llegará a: $address', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: cart.items.values
                    .map((it) => ListTile(
                          title: Text(it.title),
                          trailing: Text('x${it.quantity}'),
                          subtitle: Text('\$${(it.price * it.quantity).toStringAsFixed(2)}'),
                        ))
                    .toList(),
              ),
            ),
            FilledButton(
              onPressed: () {
                // Clear cart and go to home
                cart.clearCart();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
