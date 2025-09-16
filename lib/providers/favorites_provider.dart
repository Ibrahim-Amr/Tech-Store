import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';
import '../data/services/storage_service.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];
  final StorageService _storageService = StorageService();

  List<Product> get favorites => _favorites;

  // تصحيح نوع البيانات في دالة initialize
  void initialize(List<Product> initialFavorites) {
    _favorites.addAll(initialFavorites);
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }

  void addToFavorites(Product product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeFromFavorites(String productId) {
    _favorites.removeWhere((product) => product.id == productId);
    _saveFavorites();
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      removeFromFavorites(product.id);
    } else {
      addToFavorites(product);
    }
  }

  Future<void> _saveFavorites() async {
    await _storageService.saveFavorites(_favorites);
  }
}