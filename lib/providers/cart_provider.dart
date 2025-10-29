import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, Product> _items = {};

  Map<String, Product> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => Product(
          id: existingCartItem.id,
          title: existingCartItem.title,
          description: existingCartItem.description,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          category: existingCartItem.category,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => Product(
          id: product.id,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          category: product.category,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity > 0) {
        _items.update(
          productId,
          (existingCartItem) => Product(
            id: existingCartItem.id,
            title: existingCartItem.title,
            description: existingCartItem.description,
            price: existingCartItem.price,
            imageUrl: existingCartItem.imageUrl,
            category: existingCartItem.category,
            quantity: quantity,
          ),
        );
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
