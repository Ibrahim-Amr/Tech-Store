import 'package:flutter/foundation.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import '../data/services/storage_service.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  final StorageService _storageService = StorageService();

  List<CartItem> get items => _items;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  Future<void> initialize(List<CartItem> initialItems) async {
    _items.addAll(initialItems);
    notifyListeners();
  }

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    _saveCartItems();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCartItems();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      _saveCartItems();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCartItems();
    notifyListeners();
  }

  Future<void> _saveCartItems() async {
    await _storageService.saveCartItems(_items);
  }
}