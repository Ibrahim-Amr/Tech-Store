import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../data/models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/app_bar_with_cart.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(product.id);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBarWithCart(
        title: 'Product Details',
        showBackButton: true,
        actions: [
          // زر الإعجاب
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              if (isFavorite) {
                favoritesProvider.removeFromFavorites(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Removed from favorites')),
                );
              } else {
                favoritesProvider.addToFavorites(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with animation
            Hero(
              tag: product.id,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.image,
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.laptop, size: 100, color: Colors.blueAccent),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.blueAccent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Product Name
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Rating and Reviews
            Row(
              children: [
                RatingBar.builder(
                  initialRating: product.rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                  ignoreGestures: true,
                ),
                const SizedBox(width: 8),
                Text(
                  '(${product.reviewCount} reviews)',
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Product Category
            Text(
              product.category.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[300],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Price
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent[400],
              ),
            ),
            const SizedBox(height: 20),

            // Specifications
            if (product.brand.isNotEmpty || product.processor.isNotEmpty || product.ram.isNotEmpty || product.storage.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Specifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (product.brand.isNotEmpty)
                    _buildSpecificationItem('Brand', product.brand),
                  if (product.processor.isNotEmpty)
                    _buildSpecificationItem('Processor', product.processor),
                  if (product.ram.isNotEmpty)
                    _buildSpecificationItem('RAM', product.ram),
                  if (product.storage.isNotEmpty)
                    _buildSpecificationItem('Storage', product.storage),
                  if (product.graphics.isNotEmpty)
                    _buildSpecificationItem('Graphics', product.graphics),
                  const SizedBox(height: 20),
                ],
              ),

            // Description
            if (product.description.isNotEmpty) ...[
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.blueGrey[300],
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
            ],

            // Add to Cart and Buy Now Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cartProvider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added to cart'),
                          action: SnackBarAction(
                            label: 'View Cart',
                            onPressed: () => Navigator.pushNamed(context, '/cart'),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cartProvider.addToCart(product);
                      Navigator.pushNamed(context, '/cart');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$title:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[300],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.blueGrey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}