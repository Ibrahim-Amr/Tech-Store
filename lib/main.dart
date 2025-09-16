import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screen/cart_screen.dart';
import 'package:untitled/screen/checkout_screen.dart';
import 'package:untitled/screen/favorites_screen.dart';
import 'package:untitled/screen/home_screen.dart';
import 'package:untitled/screen/product_detail_screen.dart';
import 'package:untitled/screen/splash_screen.dart';

import 'data/models/cart_item_model.dart';
import 'data/models/product_model.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';

import 'data/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة خدمات التخزين
  final storageService = StorageService();
  await storageService.init();

  // تحميل البيانات المحفوظة مسبقاً
  final savedCartItems = await storageService.getCartItems();
  final savedFavorites = await storageService.getFavorites();

  runApp(MyApp(
    initialCartItems: savedCartItems,
    initialFavorites: savedFavorites,
  ));
}

class MyApp extends StatelessWidget {
  final List<CartItem> initialCartItems;
  final List<Product> initialFavorites;

  const MyApp({
    super.key,
    required this.initialCartItems,
    required this.initialFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider()..initialize(initialCartItems),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..initialize(initialFavorites),
        ),
      ],
      child: MaterialApp(
        title: 'TechStore',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1D1E33),
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/product_detail': (context) => const ProductDetailScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
        },
      ),
    );
  }
}