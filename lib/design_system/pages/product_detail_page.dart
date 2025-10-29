import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../templates/product_detail_template.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;

    return ProductDetailTemplate(
      product: product,
      cartCount: cartCount,
      onAddToCart: () {
        context.read<CartProvider>().addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto agregado al carrito')),
        );
      },
      onCartTap: () => Navigator.pushNamed(context, '/cart'),
    );
  }
}