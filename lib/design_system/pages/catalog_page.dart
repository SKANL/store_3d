import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_catalog.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../templates/catalog_template.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String? _selectedCategory;

  List<String> get _categories => productCatalog.map((p) => p.category).toSet().toList()..sort();

  List<Product> get _visibleProducts => _selectedCategory == null
      ? productCatalog
      : productCatalog.where((p) => p.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;

    return CatalogTemplate(
      products: _visibleProducts,
      categories: _categories,
      selectedCategory: _selectedCategory,
      onCategorySelected: (c) => setState(() => _selectedCategory = c),
      cartCount: cartCount,
      onProductSelected: (p) => Navigator.pushNamed(
        context,
        '/detail',
        arguments: p,
      ),
    );
  }
}