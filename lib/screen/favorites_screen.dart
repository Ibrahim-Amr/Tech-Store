import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/app_bar_with_cart.dart';
import '../widgets/custom_widget_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteProducts = favoritesProvider.favorites;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBarWithCart(
        title: 'Favorites',
        showBackButton: true,
      ),
      body: favoriteProducts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.blueGrey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey[300],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products to your favorites list',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[400],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return CustomProductCard(
            product: product,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product_detail',
                arguments: product,
              );
            },
            onFavoriteTap: () => favoritesProvider.removeFromFavorites(product.id),
            isFavorite: true,
          );
        },
      ),
    );
  }
}