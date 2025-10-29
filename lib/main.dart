import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product_model.dart';
import 'providers/cart_provider.dart';
import 'design_system/pages/main_shell.dart';
import 'design_system/pages/product_detail_page.dart';
import 'design_system/pages/cart_page.dart';
import 'design_system/pages/checkout_page.dart';
import 'design_system/pages/order_confirmation_page.dart';
import 'design_system/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart Atomic',
      debugShowCheckedModeBanner: false,
      theme: appThemeData(),
      home: const MainShell(),
      routes: {
        '/cart': (_) => const CartPage(),
        '/checkout': (_) => const CheckoutPage(),
        '/order-confirmation': (_) => const OrderConfirmationPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail' && settings.arguments is Product) {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          );
        }
        return null;
      },
    );
  }
}
