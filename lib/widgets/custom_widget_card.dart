import 'package:flutter/material.dart';
import '../data/models/product_model.dart';

class CustomProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const CustomProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: const Color(0xFF1D1E33),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with Hero animation
                Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.laptop, size: 50, color: Colors.blueAccent[400]),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[800],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.blueAccent[400],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Product Category and Rating
                      Row(
                        children: [
                          Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey[300],
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey[300],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Product Price
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent[400],
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorite icon and Arrow icon
                Column(
                  children: [
                    if (onFavoriteTap != null)
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: onFavoriteTap,
                        iconSize: 20,
                      ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueAccent,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}