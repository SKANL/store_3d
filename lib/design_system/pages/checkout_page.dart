import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final total = cart.totalAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => (v == null || v.isEmpty) ? 'Ingrese su nombre' : null,
                onSaved: (v) => _name = v ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Dirección de envío'),
                validator: (v) => (v == null || v.isEmpty) ? 'Ingrese una dirección' : null,
                onSaved: (v) => _address = v ?? '',
              ),
              const SizedBox(height: 20),
              Text('Resumen', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.titleMedium),
                  Text('\$${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            // In a real app we'd call an API. Here we simulate success.
                            Navigator.pushNamed(context, '/order-confirmation', arguments: {
                              'name': _name,
                              'address': _address,
                            });
                            // Keep cart clearing in the confirmation page after final ack.
                          }
                        },
                  child: const Text('Pagar ahora'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
