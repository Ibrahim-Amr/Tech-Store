import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveCartItems(List<CartItem> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _prefs.setString('cart_items', json.encode(jsonList));
  }

  Future<List<CartItem>> getCartItems() async {
    final jsonString = _prefs.getString('cart_items');
    if (jsonString != null) {
      try {
        final jsonList = json.decode(jsonString) as List;
        return jsonList.map((item) => CartItem.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> saveFavorites(List<Product> products) async {
    final jsonList = products.map((product) => product.toJson()).toList();
    await _prefs.setString('favorite_products', json.encode(jsonList));
  }

  Future<List<Product>> getFavorites() async {
    final jsonString = _prefs.getString('favorite_products');
    if (jsonString != null) {
      try {
        final jsonList = json.decode(jsonString) as List;
        return jsonList.map((product) => Product.fromJson(product)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
}