import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/product_model.dart';
import '../data/services/api_service.dart';
import '../providers/favorites_provider.dart';
import '../widgets/app_bar_with_cart.dart';
import '../widgets/custom_widget_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final data = await _apiService.getProducts();
      setState(() {
        _products = data.map((json) => Product.fromJson(json)).toList(); // تحويل البيانات إلى List<Product>
        _isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToProductDetail(Product product) {
    Navigator.pushNamed(
      context,
      '/product_detail',
      arguments: product,
    );
  }

  void _navigateToFavorites() {
    Navigator.pushNamed(context, '/favorites');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBarWithCart(
        title: 'Laptops',
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _navigateToFavorites,
            tooltip: 'Favorites',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      )
          : _errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading products',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey[300],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Try Again'),
            ),
          ],
        ),
      )
          : _products.isEmpty
          ? const Center(
        child: Text(
          'No products available',
          style: TextStyle(color: Colors.white),
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            final isFavorite = favoritesProvider.isFavorite(product.id);

            return AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Transform.translate(
                offset: Offset(0, index * 20.0),
                child: CustomProductCard(
                  product: product,
                  onTap: () => _navigateToProductDetail(product),
                  onFavoriteTap: () => favoritesProvider.toggleFavorite(product),
                  isFavorite: isFavorite,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}